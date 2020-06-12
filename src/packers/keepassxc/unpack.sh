#!/bin/bash

cp -r "$DIR_STORE/keepassxc" ~/.config

if ! which keepassxc >/dev/null; then
    sudo add-apt-repository ppa:phoerious/keepassxc && \
    apt-install.sh keepassxc 
fi
