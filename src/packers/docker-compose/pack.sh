#!/bin/bash

. "$SRC_CONFIG"

if [ -n "$install_dir" ]; then
    echo "$install_dir" > "$DIR_STORE/install_dir"
fi