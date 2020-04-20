#!/bin/bash

dconf dump / > "$DIR_STORE/user.dconf"
mkdir -p "$DIR_STORE/.local/share"
cp -r ~/.local/share/themes "$DIR_STORE/.local/share"
cp -r ~/.local/share/gnome-shell "$DIR_STORE/.local/share"
cp -r ~/.local/share/backgrounds "$DIR_STORE/.local/share"