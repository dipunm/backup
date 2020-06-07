#!/bin/bash

which gdebi > /dev/null || sudo apt update && sudo apt install gdebi-core

. "$DIR_STORE/debs.conf"

for deb in "${SOURCES[@]}"
do
    if [[ "$deb" =~ "^https?:\/\/" ]]; then
        wget -qO- "$deb" > "$DIR_TMP/tmp.deb"
        sudo gdebi "$DIR_TMP/tmp.deb"
    fi
done

for deb in "$DIR_STORE"/**/*.deb
do
    echo "installing $(basename "$deb")"
    sudo gdebi "$deb"
done