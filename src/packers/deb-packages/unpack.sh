#!/bin/bash

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
        wget -qO- "$deb" > "$DIR_TMP/tmp.deb" || exit
        gdebi.sh "$DIR_TMP/tmp.deb" || exit
    fi
done

for deb in "${LOCALDEBS[@]}"
do
    gdebi.sh "$deb" || exit
done