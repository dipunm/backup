#!/bin/bash

which gdebi >/dev/null || sudo apt-get install gdebi-core -y || exit 1
if [ apt-cache show "$1" >/dev/null 2>&1 ]; then
    ask.sh -n "$1: is already installed. Re-install?" || exit 0
fi

echo "Installing $(basename "$1")"
sudo gdebi "$1" --non-interactive
