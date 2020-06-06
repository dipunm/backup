#!/bin/bash

if ! which bcompare >/dev/null; then
    wget -O- https://www.scootersoftware.com/bcompare-4.3.4.24657_amd64.deb > "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb"
    sudo apt-get update
    which gdebi >/dev/null || sudo apt-get install gdebi-core -y
    sudo gdebi "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb" --non-interactive
else
    # upgrade
    sudo apt-get install bcompare    
fi

# see: https://www.scootersoftware.com/v4help/index.html?where_settings_are_stored.html
# ~/"${XDG_CONFIG_HOME:-.config}" takes care of default install directory and the fallback. 
# bcompare* takes care of version specific configs
CONF_DIR=~/"${XDG_CONFIG_HOME:-.config}"
mkdir -p "$CONF_DIR"
cp -r "$DIR_STORE/bcompare"* "$CONF_DIR"