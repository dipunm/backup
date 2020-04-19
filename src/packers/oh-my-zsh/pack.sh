#!/bin/bash

echo $ZSH > "$DIR_STORE/ZSH"
mkdir -p "$DIR_STORE/home"
mkdir -p "$DIR_STORE/omz"
cp -r "$ZSH/." "$DIR_STORE/omz"
cp ~/.zshrc "$DIR_STORE/home"
cp ~/.profile "$DIR_STORE/home"