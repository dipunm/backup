#!/bin/bash

# Create secure tmp folder located in the users home directory.
# It's important that this data does not move to another drive unencrypted.
HOME=~
TMP="$HOME/.tmp$(date '+%s')"
trap "rm -rf '$TMP.d'; rm $TMP.tar" EXIT
mkdir -p "$TMP.d"

. "$SRC_CONFIG"

if [ "${#FILES[@]}" -gt "0" ]; then
    for path in "${FILES[@]}"; do
        mkdir -p "$( dirname "$TMP.d/$path" )";
        cp -r "$HOME/$path" "$TMP.d/$path";
    done
fi

tar -cf "$TMP.tar" -C "$TMP.d" .
gpg --symmetric --cipher-algo AES256 --pinentry-mode loopback --output "$DIR_STORE/secure.tar.gpg" "$TMP.tar"
rm -rf "$TMP.d"
