#!/bin/bash

system_connections="/etc/NetworkManager/system-connections"

sudo rsync -b --suffix=".backup" "$DIR_STORE/system-connections" "$(dirname $system_connections)"
sudo chown -R root:root "$system_connections"
