#!/bin/bash

cp -r "$DIR_STORE/." ~

if ! which rider>/dev/null; then
    sudo apt install git -y;
fi

if ! which datagrip>/dev/null; then
    sudo apt install git -y;
fi