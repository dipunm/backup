#!/bin/bash

rsync -rab --backup-dir=backup~ "$DIR_STORE/.local/share" ~/.local
echo "dconf stores gnome settings like keyboard and gnome extension configurations"
if ask.sh -n "Would you like us to create a backup of your dconf?"; then
    path=~/user.dconf~
    dconf dump / > "$path"
    echo "Backup created at $path"
fi
dconf load / < "$DIR_STORE/user.dconf"