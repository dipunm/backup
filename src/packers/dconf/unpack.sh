#!/bin/bash

dconf dump / > "$DIR_TMP/user_dconf.backup"
dconf load / < "$DIR_STORE/user.dconf"
