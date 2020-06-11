#!/bin/bash
assert_no_sudo() {
  [ ! -n "$SUDO_USER" ] && return
  echo "sudo detected." 1>&2
  echo "You must run this program without elevated priviliges."
  exit 1
}; assert_no_sudo;

export BACKUP_USR_ROOT="${BACKUP_USR_ROOT:-"$HOME/.backup"}"

. "$BACKUP_USR_ROOT/src/lib/fs.sh"
import lib/assert lib/io lib/parse lib/info

init_dirs() {
    export DIR_TMP_CONTAINER="$BACKUP_USR_ROOT/backup$(date '+%s').tmp"
    export DIR_TMP="$DIR_TMP_CONTAINER/tmp"
    export DIR_PARCELS="$DIR_TMP_CONTAINER/parcels"
    
    cleanup_message=$(echo "cleaning up temporary files."$'\n')
    trap "echo '$cleanup_message'; rm -rf '$DIR_TMP_CONTAINER'" EXIT
    mkdir -p "$DIR_TMP"; mkdir -p "$DIR_PARCELS"; mkdir "$DIR_TMP_CONTAINER/configs";
}

detect_packers_for_backup() {
    echo $'\n'"detecting appropriate packers."$'\n'
    local all_packers=()
    mapfile -t all_packers <<< $( ls "$1" | sort -V )
    for packer in "${all_packers[@]}"; do
        packer="$1/$packer"
        local basename_packer="$(basename "$packer")"
        local friendly_name="$( head -n 1 $packer/name 2>/dev/null )"
        local key="${friendly_name:-$basename_packer}"
        
        if [ -f "$packer/detect.sh" ]; then
            (
                export SRC_CONFIG="$DIR_TMP_CONTAINER/configs/$key.conf"
                trap "rm $SRC_CONFIG" EXIT
                echo "${configs["$key"]}" > "$SRC_CONFIG"
                "$packer/detect.sh"
            ) && \
            packers["$key"]="$packer" && \
            packers_inorder+=( "$key" )
            
        fi
    done
}

detect_packers() {
    local all_packers=()
    mapfile -t all_packers <<< $( ls "$1" | sort -V )
    for packer in "${all_packers[@]}"; do
        packer="$1/$packer"
        local basename_packer="$(basename "$packer")"
        local friendly_name="$( head -n 1 $packer/scripts/name 2>/dev/null )"
        local key="${friendly_name:-"$basename_packer"}"

        if [ -f "$packer/scripts/detect.sh" ]; then
            packers["$key"]="$packer/scripts"
            packers_inorder+=( "$key" )
        fi
    done
}

cp_packers_to_parcel() {
    for name in "${!packers[@]}"; do
        local src_path="${packers["$name"]}"
        local dest_path="$DIR_PARCELS/$name/scripts"
        mkdir -p "$dest_path"
        cp -r "$src_path/." "$dest_path" 
        packers["$name"]="$dest_path"
    done
}

arr_contains() {
    item="$1"
    array=( "${@:2}" )
    for i in "${array[@]}"; do
        [ "$i" = "$item" ] && return 0;
    done
    return 1
}

build_configs() {
    local section=''
    while read -r line; do
        if ( echo -n "$line" | grep -E "^\|[^#]+\|" )>/dev/null; then
            section="$( echo $line | sed -rE 's/^\|([^#]+)\|.*$/\1/' )";
        elif [ -n "$section" ]; then
            configs["$section"]="${configs["$section"]}"$'\n'"$line"
        fi
    done < "$1"
}

backup() {
    init_dirs;
    declare -A configs=()
    build_configs "$BACKUP_USR_ROOT/configs/main.conf"

    DIR_OUTPUT="${DIR_OUTPUT:-$(pwd)}"
    declare -A packers=()
    packers_inorder=()
    detect_packers_for_backup "$BACKUP_USR_ROOT/src/packers"

    # By copying packers to the parcel before executing, the scripts 
    # for backup and restore can become similar
    cp_packers_to_parcel;
    local failures=()

    echo "packers found:"; for name in "${packers_inorder[@]}"; do 
        [ -n "$name" ] && echo "> $name"; 
    done; echo; continue_prompt 
    
    for name in "${packers_inorder[@]}"; do
        packer="${packers["$name"]}"

        if [ -f "$packer/pack.sh" ]; then
            echo "packing: $name"
            echo "=================="$'\n'
            ( # brackets create a subshell with a contained scope.
                export SRC_CONFIG="$DIR_TMP_CONTAINER/configs/$name.conf"
                trap "rm $SRC_CONFIG" EXIT
                echo "${configs["$name"]}" > "$SRC_CONFIG"
                export DIR_STORE="$DIR_PARCELS/$name/store"
                export DIR_WORKING="$packer"
                mkdir -p "$DIR_STORE"
                "$packer/pack.sh"
                
                e_code="$?"

                [ "$e_code" = "0" ] && \
                    { echo "completed successfully."$'\n'; } || \
                    { echo "exited with code $e_code."; continue_prompt; } 

                exit "$e_code";
            )
            [ "$?" = "0" ] || failures+=( "$name" )
            echo;
        fi
    done
    if [ "${#failures[@]}" -gt "0" ]; then
        echo "the following parcels will be excluded:"; for name in "${failures[@]}"; do 
            [ -n "$name" ] && echo "> $name"; 
        done; echo;
    fi

    touch "$DIR_TMP_CONTAINER/order"
    ( for p in "${packers_inorder[@]}"; do
        echo "$p"
    done ) > "$DIR_TMP_CONTAINER/order"

    continue_prompt "Ready to create archive."

	local hash=$(date +'%Y-%m-%d-%H%M%S')
    echo $'\n'"creating archive"
	echo "output: $DIR_OUTPUT/backup_$hash.tar.gz"

    tar -czf "$DIR_OUTPUT/backup_$hash.tar.gz" -C "$DIR_TMP_CONTAINER" "parcels" "order" >/dev/null
    echo "backup complete."
}

restore() {
    init_dirs;
    echo "Extracting archive..."
    tar -xzf "$ARCHIVE" -C "$DIR_TMP_CONTAINER" "parcels" "order"
    
    declare -A packers=()
    detect_packers "$DIR_TMP_CONTAINER/parcels"
    local failures=()
    local order=()
    mapfile -t order <<< $( cat "$DIR_TMP_CONTAINER/order" );
    if [ "${#PARCELS[@]}" -gt "0" ]; then
        mapfile -t order <<< $( for i in "${order[@]}"; do arr_contains "$i" "${PARCELS[@]}" && echo "$i"; done );
    fi

    echo "packers found:"; for name in "${order[@]}"; do 
        [ -n "$name" ] && echo "> $name"; 
    done; echo; continue_prompt "Ready to unpack parcels."
    
    for name in "${order[@]}"; do
        packer="${packers["$name"]}"
        if [ -f "$packer/unpack.sh" ]; then
            echo "unpacking: $name"
            echo "=================="$'\n'
            ( # brackets create a subshell with a contained scope.
                export DIR_STORE="$DIR_PARCELS/$name/store"
                export DIR_WORKING="$packer"
                mkdir -p "$DIR_STORE"
                "$packer/unpack.sh"
                
                e_code="$?"

                [ "$e_code" = "0" ] && \
                    { echo "completed successfully."$'\n'; } || \
                    { echo "exited with code $e_code."; continue_prompt; } 

                exit "$e_code";
            )
            [ "$?" = "0" ] || failures+=( "$name" )
            echo;
        fi
    done
    if [ "${#failures[@]}" -gt "0" ]; then
        echo "the following packers error'd while unpacking:"; for name in "${failures[@]}"; do 
            [ -n "$name" ] && echo "> $name"; 
        done; echo;
    fi

    echo "restore complete."
}

unset ARCHIVE
unset PACKERS
parse_command $1

if [ -n "$2" ]; then
  case "$COMMAND" in
    backup)
      parse_backup_args "${@:2}"
    ;;
    restore)
      parse_restore_args "${@:2}"
    ;;	
  esac
fi


$COMMAND # ENGAGE!