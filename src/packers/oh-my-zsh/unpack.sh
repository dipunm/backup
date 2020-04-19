#!/bin/bash

export ZSH="$( cat "$DIR_STORE/ZSH" )"
mkdir -p "$(dirname $ZSH)"
cp -r "$DIR_STORE/omz/." "$ZSH"
cp -r "$DIR_STORE/home/." ~