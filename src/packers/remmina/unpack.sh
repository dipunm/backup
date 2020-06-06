#!/bin/bash

cp -r "$DIR_STORE/." ~

if ! which remmina > /dev/null; then
    sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
    sudo apt update
    sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret
fi