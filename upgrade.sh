#!/bin/bash

[ ! -d "$BACKUP_USR_ROOT" ] && echo "backup root not found at: $BACKUP_USR_ROOT" && exit 1
BACKUP_INSTALL_OVERRIDE="don't install"
. "$BACKUP_USR_ROOT/installer.sh"

download
copy_files && install_recipes

rm -rf "$BACKUP_USR_ROOT/src"
cp -r "$SOURCE/src" "$BACKUP_USR_ROOT"

for recipe in "$SOURCE/recipes"/*
do 
(
    name=$(basename "$recipe")
    if [ -d "$BACKUP_USR_ROOT/recipes/$name" ]; then
        rm -rf "$BACKUP_USR_ROOT/recipes/$name"
        cp -r "$recipe" "$BACKUP_USR_ROOT/recipes/$name"
    else 
        cp -r "$SOURCE/recipes/$name" "$BACKUP_USR_ROOT/recipes"
    fi
) 
done
