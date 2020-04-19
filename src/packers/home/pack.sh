#!/bin/bash

# Backup this application config.
mkdir -p "$DIR_STORE/BACKUP_USR_ROOT/configs"
cp "$BACKUP_USR_ROOT/configs/main.conf" "$DIR_STORE/BACKUP_USR_ROOT/configs"