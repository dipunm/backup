#!/bin/bash

# Useful refs:
# https://wiki.debian.org/SourcesList#sources.list_format
# http://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html#the%20deb%20and%20deb-src%20types:%20general%20format

glue_deb_line() {
    # join options with url (replace spaces with '%%%')
    # this will make comparison easier later on and is reversible.
    reg_options="^(.*)(\[.+\]\s+)(.*)$"
    if [[ $1 =~ $reg_options ]]; then
        joined="$(echo "${BASH_REMATCH[2]}" | sed 's/\s/%%%/g')"
        echo "${BASH_REMATCH[1]}$joined${BASH_REMATCH[3]}"
    else
        echo "$1"
    fi
}

unglue_deb_line() {
    echo ${@} | sed 's/%%%/ /g'
}

## Reads each source, splits any multi-component declarations into multiple 
## single-component declarations and saves into an array.
read_sources() {
    while read -r line ; do
        line="$(glue_deb_line "$line")"

        # format: deb [opts%%%]uri suite component [component...]
        segments=( $line )
        components=( "${segments[@]:3}" )
        for component in "${components[@]}"
        do
            # expand each component into separate array values
            echo "${segments[0]} ${segments[1]} ${segments[2]} $component"
        done
    done <<< $( grep '^\s*deb\s' $1 | sed 's/#.*//' )
}

compare_sources() {
        for store_line in "${store_sources[@]}"; do
        local has_dup="false"
        local has_alt="false"
        for os_line in "${os_sources[@]}"; do
            if [ "$store_line" = "$os_line" ]; then
                has_dup="true"
                has_alt="false"
                duplicates+=( "$store_line" )
                unset altsuite_repos["$store_line"]
                break;
            fi

            store_segments=( $store_line )
            os_segments=( $os_line )
            if [ "${store_segments[0]} ${store_segments[1]} ${store_segments[3]}" = "${os_segments[0]} ${os_segments[1]} ${os_segments[3]}" ]; then
                altsuite_repos["$store_line"]="${altsuite_repos["$store_line"]} ${os_segments[2]}"
                has_alt="true"
            fi    
        done
        if [ "$has_dup" = "false" ] && [ "$has_alt" = "false" ]; then
            new_repos+=( "$store_line" )
        fi
    done

}

print_compare_results() {
    echo "\
# Modify, save and exit to continue.
# ====================================
# This file contains a list of sources to install. Your backup has been compared 
# against your systems existing sources.list file and we have documented
# similarities to help you make informed decisions while editing this file.

# Note: this file will be parsed. All lines beginning with # will be ignored and 
# other lines will be added to your sources using the command:
# sudo add-apt-repository <line>

# You may inspect and modify this file before continuing.
# To better understand the deb format, see:
# http://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html#the%20deb%20and%20deb-src%20types:%20general%20format
# TLDR; the format is: 
# deb [ option1=value1 option2=value2 ] uri suite [component1] [component2] [...]
# ====================================="

    echo "
###
# These sources are new and safe to install. You may omit any line that you wish
# not to install by commenting them out. You may also remove these sources after 
# installation by calling: 
# sudo apt-add-repository --remove <line>
###
"
    for new in "${new_repos[@]}";
    do
        echo "$(unglue_deb_line "$new")"
    done

    echo "
###
# These sources are very similar to ones already defined; they differ only by suite.
# Typically this happens after an OS upgrade. There could be sources that you 
# genuinely need to install; you should uncomment those lines before continuing.
###
"
        for key in "${!altsuite_repos[@]}";
        do
            echo "\
# This source exists for the following suites: ${altsuite_repos["$key"]}
# $(unglue_deb_line "$key")
"
        done

    echo "
###
# These sources are duplicates; there is no need to install these again.
# This exists for informational purposes only.
###
"
    for dup in "${duplicates[@]}";
    do
        echo "# $(unglue_deb_line "$dup")"
    done
}

merge_main_sources() {
    local os_sources=()
    local store_sources=()

    mapfile -t os_sources <<< $( read_sources /etc/apt/sources.list )
    mapfile -t store_sources <<< $( read_sources "$DIR_STORE/sources.list" )

    local duplicates=()
    local new_repos=()
    declare -A altsuite_repos=()
    compare_sources # This will read/write to our local variables.

    # allow user to control what is installed to sources.list
    print_compare_results > "$DIR_TMP/sources_whitelist"
    editor "$DIR_TMP/sources_whitelist"

    echo $'\n'"adding new repositories"
    repos_to_install="$( grep '^\s*deb\s' "$DIR_TMP/sources_whitelist" | sed 's/#.*//' | grep -v -e '^\s*$' )"
    if [ -n "$repos_to_install" ]; then
        while read -r line ; do
            sudo add-apt-repository "$line"
        done <<< "$repos_to_install"
    else
        echo "no new repositories to install."
    fi
}

main() {
    local b_suffix=".backup$(date '+%s')"
    local b_dir=/etc/apt/backups

    sudo mkdir -p "$b_dir"
    echo "restoring keys"
    sudo rsync -rb --backup-dir="$b_dir" $DIR_STORE/trusted.gpg.d /etc/apt
    # it is safe to have duplicate keys, so we'll just add a new key file without
    # touching the original trusted.gpg file.
    [ -f "$DIR_STORE/trusted.gpg" ] && \
    sudo cp $DIR_STORE/trusted.gpg "/etc/apt/trusted.gpg.d/restored_$(date '+%s').gpg"
    echo "done."$'\n'

    echo "restoring sources"
    echo "the following source-list files will be installed:"
    ls -1 "$DIR_STORE/sources.list.d"
    read -rs -d '' -t 0.1
    read -rsn1 -p "Press any key to continue"$'\n'
    sudo rsync -ab --backup-dir="$b_dir" "$DIR_STORE/sources.list.d" /etc/apt

    read -rs -d '' -t 0.1
    read -rsn1 -p "Ready to merge the main sources.list file. Press any key to continue"$'\n'
    sudo cp "/etc/apt/sources.list" "$b_dir"
    merge_main_sources
    echo "done."$'\n'

    sudo apt update
}

main # Engage!