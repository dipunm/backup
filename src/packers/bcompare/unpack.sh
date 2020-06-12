#!/bin/bash

if ! which bcompare >/dev/null; then
    wget -O- https://www.scootersoftware.com/bcompare-4.3.4.24657_amd64.deb > "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb" || exit
    sudo apt-get update
    gdebi.sh "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb" || exit
fi

# upgrade
apt-install.sh bcompare || exit

# see: https://www.scootersoftware.com/v4help/index.html?where_settings_are_stored.html
# ~/"${XDG_CONFIG_HOME:-.config}" takes care of default install directory and the fallback. 
# bcompare* takes care of version specific configs
CONF_DIR=~/"${XDG_CONFIG_HOME:-.config}"
mkdir -p "$CONF_DIR"
cp -r "$DIR_STORE/bcompare"* "$CONF_DIR"