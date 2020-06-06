#!/bin/bash

lsb_release -a 2>/dev/null > "$DIR_STORE/lsb_release"

if [ -d "/etc/apt/preferences.d" ]; then
    cp -r /etc/apt/preferences.d "$DIR_STORE" || exit
fi

if [ -d "/etc/apt/sources.list.d" ] && [ "$(ls -1 /etc/apt/sources.list.d/*.list | wc -l)" -gt "0" ]; then
    mkdir "$DIR_STORE/sources.list.d"
    cp /etc/apt/sources.list.d/*.list "$DIR_STORE/sources.list.d" || exit
fi

if [ -d "/etc/apt/trusted.gpg.d" ]; then
    mkdir "$DIR_STORE/trusted.gpg.d"
    if [ "$(ls -1 /etc/apt/trusted.gpg.d/*.gpg | wc -l)" -gt "0" ]; then
        cp /etc/apt/trusted.gpg.d/*.gpg "$DIR_STORE/trusted.gpg.d" || exit
    fi
    if [ "$(ls -1 /etc/apt/trusted.gpg.d/*.asc | wc -l)" -gt "0" ]; then
        cp /etc/apt/trusted.gpg.d/*.asc "$DIR_STORE/trusted.gpg.d" || exit
    fi
fi

if [ -f "/etc/apt/sources.list" ]; then
    cp /etc/apt/sources.list "$DIR_STORE" || exit
fi

if [ -f "/etc/apt/trusted.gpg" ]; then
    cp /etc/apt/trusted.gpg "$DIR_STORE" || exit
fi
