#!/bin/bash

cp -r "$DIR_STORE/keepassxc" ~/.config

if ! which keepassxc >/dev/null; then
    sudo add-apt-repository ppa:phoerious/keepassxc
    sudo apt-get update
    sudo apt-get install keepassxc -y 
fi