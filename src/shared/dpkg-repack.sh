#!/bin/bash

which dpkg-repack >/dev/null || sudo apt-install.sh dpkg-repack -y || exit 1
dpkg-repack "$1"
