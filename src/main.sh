#!/bin/bash

BACKUP_USR_ROOT=${BACKUP_USR_ROOT:-"$HOME/.backup"}
# For development.
[ ! -d "$BACKUP_USR_ROOT" ] && BACKUP_USR_ROOT="$HOME/Projects/bakitup/backup" 
# For development.
. $BACKUP_USR_ROOT/src/lib/io.sh

import lib/assert lib/util lib/parse lib/info lib/backup lib/restore

assert_no_sudo
HOME=`cd ~ && pwd`
unset DIR_OUTPUT
unset RECIPE
unset ARCHIVE
parse_command $1

if [ -n "$2" ]; then
  case $COMMAND in
    backup)
      parse_backup_args ${*:2}
    ;;
    restore)
      parse_restore_args ${*:2}
    ;;	
  esac
fi

DIR_OUTPUT=${DIR_OUTPUT:-$HOME}
dir_recipes_src="$BACKUP_USR_ROOT/recipes"
dir_recipes_store="$BACKUP_USR_ROOT/store"
dir_config="$BACKUP_USR_ROOT/configs"

load_config main.conf

# execute command.
$COMMAND