#!/bin/bash

[ ! -d "$BACKUP_USR_ROOT" ] && echo "backup root not found at: $BACKUP_USR_ROOT" && exit 1
BACKUP_INSTALL_OVERRIDE="don't install"
. "$BACKUP_USR_ROOT/installer.sh"

download "development"
copy_files