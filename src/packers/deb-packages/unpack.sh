#!/bin/bash

which gdebi > /dev/null || ( sudo apt update && sudo apt install gdebi-core )

. "$DIR_STORE/debs.conf"

LOCALDEBS=( $( find "$DIR_STORE" -type f -name "*.deb" | tr ' ' '\n' | sort | uniq -u ) )
allDebs=( $( echo "${SOURCES[@]} ${LOCALDEBS[@]}" )  )

echo $'\n'"The following packages will be installed:"
for deb in "${allDebs[@]}"
do
    echo "> $deb"
done

pause.sh

for deb in "${SOURCES[@]}"
do
    if [[ "$deb" =~ "^https?:\/\/" ]]; then
        wget -qO- "$deb" > "$DIR_TMP/tmp.deb"
        sudo gdebi "$DIR_TMP/tmp.deb"
    fi
done

for deb in "${LOCALDEBS[@]}"
do
    echo "installing $(basename "$deb")"
    sudo gdebi "$deb"
done