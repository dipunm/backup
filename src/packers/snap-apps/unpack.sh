#!/bin/bash

if ! which snap >/dev/null; then
    sudo apt-get install snapd || exit
fi

if [ -f "$DIR_STORE/snap.list" ]; then
    while read line; do sudo snap install "$line"; done <"$DIR_STORE/snap.list"
fi

if [ -f "$DIR_STORE/classic.list" ]; then
    while read line; do sudo snap install "$line" --classic; done <"$DIR_STORE/classic.list"
fi
