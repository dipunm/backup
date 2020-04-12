#!/bin/bash

which gdebi > /dev/null || sudo apt install gdebi

. "$DIR_STORE/debs.conf"


for deb in "${debs[@]}"
do

    if [ -f "$deb" ]; then
        sudo gdebi "$deb"
    elif [ -d "$deb" ]; then
        for sub_deb in "$deb"/*.deb
        do
            sudo gdebi "$sub_deb"
        done
    elif [[ "$deb" =~ "^https?:\/\/" ]]; then
        wget -qO- "$deb" > "$DIR_TMP/tmp.deb"
        sudo gdebi "$DIR_TMP/tmp.deb"
    fi
done