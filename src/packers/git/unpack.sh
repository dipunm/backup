#!/bin/bash

cp -r "$DIR_STORE/.gitconfig" ~/

if ! which git>/dev/null; then
    apt-install.sh git;
fi