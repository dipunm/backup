#!/bin/bash

mkdir -p ~/.local/share/autojump
cp -r "$DIR_STORE/autojump/." ~/.local/share/autojump

if ! which autojump>/dev/null; then
    sudo apt install autojump -y;
fi