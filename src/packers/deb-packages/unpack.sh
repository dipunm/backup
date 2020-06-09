#!/bin/bash

which gdebi > /dev/null || ( sudo apt update && sudo apt install gdebi-core )

. "$DIR_STORE/debs.conf"

LOCALDEBS=( $( find "$DIR_STORE" -type f -name "*.deb" ) )
allDebs=( $( echo "${SOURCES[@]} ${LOCALDEBS[@]}" )  )

echo $'\n'"The following packages will be installed:"
for deb in "${allDebs[@]}"
do
    echo "> $deb"
done

read -rs -d '' -t 0.1
read -rsn1 -p "Press any key to continue..."$'\n'

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