#!/bin/bash
ask_backup() {
    echo "dconf stores gnome settings like keyboard and gnome extension configurations"
    read -r -p "Would you like us to create a backup of your dconf? [y/N]: " response
    case "$response" in
    [yY][eE][sS]|[yY])
        return 0
    ;;
    *)
        return 1
    ;;
    esac
}

rsync -rab --backup-dir=backup~ "$DIR_STORE/.local/share" ~/.local
if ask_backup; then
    path=~/user.dconf~
    dconf dump / > "$path"
    echo "Backup created at $path"
fi
dconf load / < "$DIR_STORE/user.dconf"