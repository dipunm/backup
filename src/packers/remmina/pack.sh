#!/bin/bash

mkdir -p "$DIR_STORE/.local/share"
cp -r ~/.local/share/remmina "$DIR_STORE/.local/share"

mkdir -p "$DIR_STORE/.config"
cp -r ~/.config/remmina "$DIR_STORE/.config"