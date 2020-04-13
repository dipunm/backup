#!/bin/bash

system_connections="/etc/NetworkManager/system-connections"

sudo rsync -rb --suffix=".backup" "$DIR_STORE/system-connections" "$(dirname $system_connections)"
sudo chown -R root:root "$system_connections"

read -r -p "Restart network manager? [Y/n]: " response
case "$response" in
[nN][oO]|[nN])
    echo "You may need to restart your machine to see changes."
;;
*)
    sudo systemctl restart network-manager
;;
esac
