#!/bin/bash

if [ ! -f "$DIR_STORE/packages.conf" ]; then
    >&2 echo "No packages found to install in config."
    exit 1
fi

. "$DIR_STORE/packages.conf"

if [ -z "$packages" ]; then
    >&2 echo "No packages found to install in config."
    exit 1
fi

sudo apt update
sudo apt install ${packages[@]}
