#!/bin/bash

read -r "$DIR_STORE/ZSH" ZSH
mkdir -p "$ZSH"
cp -r "$DIR_STORE/omz/." "$ZSH"
cp -r "$DIR_STORE/home/." ~