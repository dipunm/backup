#!/bin/bash

rsync -rab "$DIR_STORE/BACKUP_USR_ROOT/." "$BACKUP_USR_ROOT"
cp -r "$DIR_STORE/home/." ~