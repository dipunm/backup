#!/bin/bash

mkdir -p ~/.local/share/autojump
cp -r "$DIR_STORE/autojump/." ~/.local/share/autojump

if ! which autojump>/dev/null; then
    apt-install.sh autojump;
fi