#!/bin/bash
. "$SRC_CONFIG"

[ "$dpkg_repack" = "true" ] && \
    apt-clone clone --with-dpkg-repack "$DIR_STORE/apt-clone.tar.gz" || \
    apt-clone clone "$DIR_STORE/apt-clone.tar.gz"