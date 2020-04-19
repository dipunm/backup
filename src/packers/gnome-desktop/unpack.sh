#!/bin/bash

dconf dump / > "$DIR_TMP/user_dconf.backup"
dconf load / < "$DIR_STORE/user.dconf"

rsync -rab --backup-dir=~/.local/backup "$DIR_STORE/.local/share" ~/.local