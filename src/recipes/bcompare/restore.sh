#!/bin/bash

wget -qO- https://www.scootersoftware.com/bcompare-4.3.4.24657_amd64.deb > "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb"
sudo apt-get update
sudo apt-get install gdebi-core
sudo gdebi "$DIR_TMP/bcompare-4.3.4.24657_amd64.deb" && \
sudo apt upgrade bcompare