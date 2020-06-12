#!/bin/bash

mkdir -p ~/.config
cp -r "$DIR_STORE/.config" ~

if ! which code>/dev/null; then
    URL='https://go.microsoft.com/fwlink/?LinkID=760868'
    wget -qO- "$URL" > "$DIR_TMP/tmp.deb"
    gdebi.sh "$DIR_TMP/tmp.deb"
fi