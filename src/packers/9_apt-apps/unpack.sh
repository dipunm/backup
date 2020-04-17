#!/bin/bash

installed=( $( apt-mark showmanual ) )
packages=( $( cat "$DIR_STORE/packages" | sed 's/#.*//' ) )
new=( $( echo "${installed[@]} ${packages[@]}" | tr ' ' '\n' | sort | uniq -u ) )
echo "The following packages will be installed (count: ${#new[@]}):
(${new[@]})
"

read -rp "Would you like to edit before continuing? [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "# Please comment out or delete any packages you wish to prevent from installing:"$'\n' > "$DIR_TMP/edit-apts"
        echo "${new[@]}" | tr ' ' '\n' >> "$DIR_TMP/edit-apts"
        editor "$DIR_TMP/edit-apts"
        new=( $( cat "$DIR_TMP/edit-apts" | sed 's/#.*//' ) )
    ;;
esac

sudo apt install "${new[@]}" -y