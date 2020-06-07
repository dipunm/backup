#!/bin/bash

. "$SRC_CONFIG"
system_connections="/etc/NetworkManager/system-connections"
mkdir "$DIR_STORE/system-connections"

if [ "${#backup_networks[@]}" -gt "0" ]; then

    sudo chmod --reference="$system_connections" "$DIR_STORE/system-connections"
    sudo chown "$USER":"$USER" "$DIR_STORE/system-connections"

    for network in "${backup_networks[@]}"
	do
		if [ -f "$system_connections/$network.nmconnection" ]; then
			sudo cp "$system_connections/$network.nmconnection" \
                "$DIR_STORE/system-connections"
            sudo chown "$USER":"$USER" "$DIR_STORE/system-connections/$network.nmconnection"
        else
            echo "warning: network $network not found."
		fi
	done

else

    sudo cp -r "$system_connections"/*.nmconnection "$DIR_STORE/system-connections"
    sudo chown -R "$USER":"$USER" "$DIR_STORE/system-connections"

fi
