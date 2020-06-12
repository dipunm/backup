#!/bin/bash

cp -r "$DIR_STORE/." ~

if ! which remmina > /dev/null; then
    sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
    apt-install.sh remmina
fi