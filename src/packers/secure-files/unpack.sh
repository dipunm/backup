#!/bin/bash

HOME=~
TMP="$HOME/.tmp$(date '+%s')"
trap "rm $TMP.tar" EXIT

gpg --decrypt --pinentry-mode loopback --output "$TMP.tar" "$DIR_STORE/secure.tar.gpg"
tar -xf "$TMP.tar" -C "$HOME" .
