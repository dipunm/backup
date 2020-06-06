#!/bin/bash

cp "$SRC_CONFIG" "$DIR_STORE/debs.conf"

. "$DIR_STORE/debs.conf"

for deb in "${debs[@]}"
do
    # each entry goes to a unique folder to avoid name conflicts.
    outdir="$DIR_STORE/$(date '+%s')"
    mkdir -p "$outdir"
    if [ -f "$deb" ]; then
        cp "$deb" "$outdir"
    elif [ -d "$deb" ]; then
        cp -r "$deb/." "$outdir"
    fi
done
