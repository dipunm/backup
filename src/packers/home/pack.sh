#!/bin/bash

# Backup this application config.
mkdir -p "$DIR_STORE/BACKUP_USR_ROOT/configs"
cp "$BACKUP_USR_ROOT/configs/main.conf" "$DIR_STORE/BACKUP_USR_ROOT/configs"

. "$SRC_CONFIG"

if [ "${#FILES[@]}" -gt "0" ]; then
    for path in "${FILES[@]}" do
        mkdir -p "$( dirname "$DIR_STORE/home/$path" )";
        cp -r ~/"$path" "$DIR_STORE/home/$path";
    done
fi