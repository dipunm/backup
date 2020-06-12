#!/bin/bash

mkdir -p ~/.mozilla
cp -r "$DIR_STORE/.mozilla/." ~/.mozilla

if ! which firefox>/dev/null; then
  apt-install.sh firefox;
fi