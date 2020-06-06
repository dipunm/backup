#!/bin/bash

CONF_DIR=~/"${XDG_CONFIG_HOME:-.config}"
cp -r "$CONF_DIR/bcompare"* "$DIR_STORE"
