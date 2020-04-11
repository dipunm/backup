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

clean_deb_line() {
    echo ${@} | sed 's/%%%/ /g'
}    

echo_pause() {
    local message=$1
    local word=$2
    local input=
    echo "$message"
    while [ "$word" != "$input" ]; do
        read -p "Type '$word' to continue: " input
    done
}

merge_source_list() {
    local os_sources=()
    local store_sources=()
    local duplicates=()
    local new_repos=()
    declare -A altsuite_repos=()

    while read -r line ; do
        line="$(glue_deb_line "$line")"

        # format: deb [opts%%%]uri suite component [component...]
        segments=( $line )
        components=( "${segments[@]:3}" )
        for component in "${components[@]}"
        do
            # expand each component into separate array values
            os_sources+=( "${segments[0]} ${segments[1]} ${segments[2]} $component" )
        done
    done <<< $( grep '^\s*deb\s' /etc/apt/sources.list )

    while read -r line ; do
        line="$(glue_deb_line "$line")"
        
        # format: deb [opts%%%]uri suite component [component...]
        segments=( $line )
        components=( "${segments[@]:3}" )
        for component in "${components[@]}"
        do
            # expand each component into separate array values
            store_sources+=( "${segments[0]} ${segments[1]} ${segments[2]} $component" )
        done
    done <<< $( grep '^\s*deb\s' "$DIR_STORE/sources.list" )

    # deb opts+uri suite component [component...]

    # collect: dups, sdups
    for store_line in "${store_sources[@]}" 
    do
        has_dupe="false"
        for os_line in "${os_sources[@]}" 
        do
            if [ "$store_line" = "$os_line" ]; then
                has_dupe="true"
                duplicates+=( "$store_line" )
                continue
            fi

            store_segments=( $store_line )
            os_segments=( $os_line )
            if [ "${store_segments[0]} ${store_segments[1]} ${store_segments[3]}" = "${os_segments[0]} ${os_segments[1]} ${os_segments[3]}" ]; then
                altsuite_repos["$store_line"]="${altsuite_repos["$store_line"]} ${os_segments[2]}"
                has_dupe="true"
            fi
        done
        if [ "$has_dupe" = "false" ]; then
            new_repos+=( "$store_line" )
        fi
    done

    if [ "${#altsuite_repos[@]}" -gt 0 ]; then
        F_SOURCES_TMP="$DIR_TMP/similar-sources.list"
        > "$F_SOURCES_TMP"
        echo "\
# Modify, save and exit to continue.

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

" >> "$F_SOURCES_TMP"

        echo "\
###
# These sources are very similar to ones already defined; they differ only by suite.
# Typically this happens after an OS upgrade. There could be sources that you 
# genuinely need to install; uncomment those lines before continuing.
###" >> "$F_SOURCES_TMP"
        for key in "${!altsuite_repos[@]}";
        do
            echo "
# This source exists for the following suites: ${altsuite_repos["$key"]}
# $(clean_deb_line "$key")" >> "$F_SOURCES_TMP"
        done
    fi

        echo "
###
# These sources are new and safe to install. You may omit any line that you wish
# not to install by commenting them out.
###" >> "$F_SOURCES_TMP"
    for new in "${new_repos[@]}";
    do
        echo "$(clean_deb_line "$new")" >> "$F_SOURCES_TMP"
    done

        echo "
###
# These sources are duplicates; there is no need to install these again.
# This exists for informational purposes only.
###" >> "$F_SOURCES_TMP"
    for dup in "${duplicates[@]}";
    do
        echo "# $(clean_deb_line "$dup")" >> "$F_SOURCES_TMP"
    done


    which editor >/dev/null && editor "$F_SOURCES_TMP" || echo_pause "
    inspect or edit this file before continuing: 
        $F_SOURCES_TMP
    " "continue"

    echo "
backing up /etc/apt/sources.list"
    sudo cp /etc/apt/sources.list "/etc/apt/sources.list.$1"
    
    echo "
adding new repositories"
    while read -r line ; do
        sudo add-apt-repository "$line"
    done <<< $( grep '^\s*deb\s' "$F_SOURCES_TMP" )
}

echo "
restoring keys"
backup_key="backup$(date "+%s")"
sudo cp -r $DIR_STORE/trusted.gpg.d /etc/apt
# it is safe to have duplicate keys, so we'll just add a new key file without
# touching the original trusted.gpg file.
sudo cp $DIR_STORE/trusted.gpg "/etc/apt/trusted.gpg.d/$backup_key.gpg"

echo "
restoring sources"
merge_source_list "$backup_key"
sudo rsync -b suffix=".$backup_key" $DIR_STORE/sources.list.d/* /etc/apt/sources.list.d

echo "
restoring source preferences"
sudo rsync -b suffix=".$backup_key" $DIR_STORE/preferences.list.d/* /etc/apt/preferences.list.d

sudo apt update