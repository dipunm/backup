#!/bin/bash

which dpkg-repack >/dev/null || sudo apt-get install dpkg-repack -y || exit 1
dpkg-repack "$1"
