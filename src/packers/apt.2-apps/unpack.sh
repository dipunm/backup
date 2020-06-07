#!/bin/bash

installed=( $( apt-mark showmanual ) )
packages=( $( cat "$DIR_STORE/packages" | sed 's/#.*//' ) )
new=( $( echo "${installed[@]} ${packages[@]}" | tr ' ' '\n' | sort | uniq -u ) )

if [ "${#new[@]}" = "0" ]; then
    exit 0;
fi
sudo apt update

available=( $( { apt-cache pkgnames && echo "${new[@]}" | tr ' ' '\n'; } | sort | uniq -d ) )
unavailable=( $( echo "${available[@]} ${new[@]}" | tr ' ' '\n' | sort | uniq -u ) )


if [ "${#unavailable[@]}" -gt "0" ]; then
    echo "The following packages are not available to install:"
    for pkg in "${unavailable[@]}"; do
        echo "> $pkg"
    done
    echo "These packages may require installation from a .deb file, or \
an apt-repository to be installed using apt-add-repository"
    read -rs -d '' -t 0.1
 	read -rsn1 -p "Press any key to continue..."$'\n'
fi

echo "The following packages will be installed (count: ${#available[@]}):
(${available[@]})
"

read -rp "Would you like to edit before continuing? [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "# Please comment out or delete any packages you wish to prevent from installing:"$'\n' > "$DIR_TMP/edit-apts"
        echo "${available[@]}" | tr ' ' '\n' >> "$DIR_TMP/edit-apts"
        editor "$DIR_TMP/edit-apts"
        pkgs=( $( cat "$DIR_TMP/edit-apts" | sed 's/#.*//' ) )
    ;;
esac

sudo apt install "${pkgs[@]}" -y