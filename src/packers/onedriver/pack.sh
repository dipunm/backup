#!/bin/bash

ls -1 ~/.config/systemd/user/default.target.wants/onedriver@* | sed 's/.*@//' | sed 's/.service//' | sed 's/-/\//g' | sed "s#$HOME#\$HOME#" \
> "$DIR_STORE/path"
mkdir -p "$DIR_STORE/.cache"
cp -r ~/.cache/onedriver "$DIR_STORE/.cache"
rm "$DIR_STORE/.cache"/*/*.db || true
rm "$DIR_STORE/.cache"/*.db || true
