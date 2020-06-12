#!/bin/bash

sudo apt update
# already installed packages
installed=( $( apt-mark showmanual ) $( apt-mark showauto ) )
# packages to restore
packages=( $( cat "$DIR_STORE/packages" | sed 's/#.*//' ) )
# packages already installed
existing=( $( echo "${installed[@]} ${packages[@]}" | tr ' ' '\n' | sort | uniq -d ) )
# packages left to restore
new=( $( echo "${existing[@]} ${packages[@]}" | tr ' ' '\n' | sort | uniq -u ) )

if [ "${#new[@]}" = "0" ]; then
    exit 0;
fi

# wanted packages that are available to install
available=( $( { apt-cache pkgnames && echo "${new[@]}" | tr ' ' '\n'; } | sort | uniq -d ) )
# wanted packages that are unavailable to install
unavailable=( $( echo "${available[@]} ${new[@]}" | tr ' ' '\n' | sort | uniq -u ) )

if [ "${#unavailable[@]}" -gt "0" ]; then
    echo "The following packages are not available to install:"
    for pkg in "${unavailable[@]}"; do
        echo "> $pkg"
    done
    echo "These packages may require installation from a .deb file, or \
an apt-repository to be installed using apt-add-repository"
    pause.sh
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

apt-install.sh "${pkgs[@]}" -y