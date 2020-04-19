#!/bin/bash

if which apt-get; then
    if ! which bcompare; then
        wget -O- https://www.scootersoftware.com/bcompare-4.3.4.24657_amd64.deb > "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb"
        sudo apt-get update
        sudo apt-get install gdebi-core
        sudo gdebi "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb" --non-interactive
    else
        # upgrade
        sudo apt install bcompare
    fi
else
    echo "unsupported distribution: unable to install beyond compare."
    read -r -p "Would you like to restore your configuration anyway? [y/N]: " response
    case "$response" in
    [yY][eE][sS]|[yY])
        true
    ;;
    *)
        exit 1
    ;;
    esac
fi

# see: https://www.scootersoftware.com/v4help/index.html?where_settings_are_stored.html
# ~/"${XDG_CONFIG_HOME:-.config}" takes care of default install directory and the fallback. 
# bcompare* takes care of version specific configs
CONF_DIR=~/"${XDG_CONFIG_HOME:-.config}"
mkdir -p "$CONF_DIR"
cp -r "$DIR_STORE/bcompare"* "$CONF_DIR" 