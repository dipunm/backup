#!/bin/bash

cp -r "$DIR_STORE/.gitconfig" ~/

if ! which git>/dev/null; then
    sudo apt install git -y;
fi