#!/bin/bash

ls -1 ~/.config/systemd/user/default.target.wants/onedriver@* | sed 's/.*@//' | sed 's/.service//' | sed 's/-/\//g' | sed "s#$HOME#\$HOME#" \
> "$DIR_STORE/path"