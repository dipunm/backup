#!/bin/bash

which gdebi > /dev/null || sudo apt update && sudo apt install gdebi

. "$DIR_STORE/debs.conf"


for deb in "${debs[@]}"
do
    if [[ "$deb" =~ "^https?:\/\/" ]]; then
        wget -qO- "$deb" > "$DIR_TMP/tmp.deb"
        sudo gdebi "$DIR_TMP/tmp.deb"
    fi
done

for deb in "$DIR_STORE"/**/*.deb
do
    sudo gdebi "$deb"
done