#!/bin/bash

if [ ! -f $SRC_CONFIG ]; then
    >&2 echo "Unable to load configuration file: $SRC_CONFIG"
    exit 1
fi

. "$SRC_CONFIG"

if [ -z "$packages" ]; then
    >&2 echo "No packages found to install in config."
    exit 1
fi

cp "$SRC_CONFIG" "$DIR_STORE/packages.conf"