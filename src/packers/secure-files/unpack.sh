#!/bin/bash

HOME=~
TMP="$HOME/.tmp$(date '+%s')"
trap "rm $TMP.tar" EXIT

echo "Restoring secure files. This will override your original files."
gpg --decrypt --pinentry-mode loopback --output "$TMP.tar" "$DIR_STORE/secure.tar.gpg" || exit
echo "The following files will be replaced:"
tar -tf "$TMP.tar"
ask.sh "Replace your secure files?" || exit 0
tar -xf "$TMP.tar" -C "$HOME" .
