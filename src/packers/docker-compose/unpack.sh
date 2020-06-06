#!/bin/bash

if [ -f "$DIR_STORE/install_dir" ]; then
    install_dir=$( read -r $DIR_STORE/install_dir )
fi

: ${install_dir:="/usr/local/bin"}

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o "$install_dir/docker-compose"
sudo chmod +x "$install_dir/docker-compose"
