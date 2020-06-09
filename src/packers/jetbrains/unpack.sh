#!/bin/bash

cp -r "$DIR_STORE/.config" ~

apps=()
mapfile -t apps < "$DIR_STORE/installed"
for app in "${apps[@]}"; do
    sudo -E "$DIR_WORKING/installer.sh" $app || exit 1
done
