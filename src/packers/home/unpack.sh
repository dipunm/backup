#!/bin/bash

ask() {
    read -r -p "$1" response
    case "$response" in
    [Yy][Ee][Ss]|[Yy])
        return 0
    ;;
    *)
        return 1
    ;;
    esac
}

rsync -rab "$DIR_STORE/BACKUP_USR_ROOT/." "$BACKUP_USR_ROOT"
cp -r "$DIR_STORE/home/." ~