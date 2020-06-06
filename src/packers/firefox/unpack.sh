#!/bin/bash

mkdir -p ~/.mozilla
cp -r "$DIR_STORE/.mozilla/." ~/.mozilla

if ! which firefox>/dev/null; then
    sudo apt install firefox -y;
fi