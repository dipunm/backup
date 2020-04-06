#!/bin/bash

BACKUP_USR_ROOT=${BACKUP_USR_ROOT:-"$HOME/.backup"}
# For development.
[ ! -d "$BACKUP_USR_ROOT" ] && BACKUP_USR_ROOT="$HOME/Projects/backup"
# For development.
. $BACKUP_USR_ROOT/src/lib/io.sh

import lib/assert lib/util lib/parse lib/info lib/backup lib/restore

HOME=`cd ~ && pwd`
DIR_OUTPUT=${DIR_OUTPUT:-$HOME}
dir_recipes_src="$BACKUP_USR_ROOT/recipes"
dir_recipes_store="$BACKUP_USR_ROOT/store"
dir_recipes_config="$BACKUP_USR_ROOT/configs"
dir_config="$BACKUP_USR_ROOT/configs"

assert_no_sudo
load_config main.conf

unset DIR_OUTPUT
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

mk_dir_tmp
cleanup_message=$(echo "cleaning up temporary files."$'\n')
trap 'echo $cleanup_message ; rm -rf $dir_recipes_store $dir_tmp' EXIT

# execute command.
$COMMAND