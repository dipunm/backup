#!/bin/bash

lsb_release -a 2>/dev/null > "$DIR_STORE/lsb_release"

if [ -d "/etc/apt/preferences.d" ]; then
    cp -r /etc/apt/preferences.d "$DIR_STORE" || exit
fi

if [ -d "/etc/apt/sources.list.d" ]; then
    cp -r /etc/apt/sources.list.d "$DIR_STORE" || exit
fi

if [ -d "/etc/apt/trusted.gpg.d" ]; then
    cp -r /etc/apt/trusted.gpg.d "$DIR_STORE" || exit
fi

if [ -f "/etc/apt/sources.list" ]; then
    cp /etc/apt/sources.list "$DIR_STORE" || exit
fi

if [ -f "/etc/apt/trusted.gpg" ]; then
    cp /etc/apt/trusted.gpg "$DIR_STORE" || exit
fi
