#!/bin/bash

cp -r "$DIR_STORE/." ~

apps=()
mapfile -t apps < "$DIR_STORE/installed"
for app in "${apps[@]}"; do
    sudo "$DIR_WORKING/installer.sh" $app
done
