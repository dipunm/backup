: ${system_connections:="/etc/NetworkManager/system-connections"}

if [ ${#backup_networks[*]} -gt 0 ]; then

    mkdir $recipe_data/system-connections
    sudo chmod --reference=$system_connections $recipe_data/system-connections
    sudo chown $USER:$USER $recipe_data/system-connections

    for network in "${backup_networks[@]}"
	do
		if [ -f $system_connections/$network.nmconnection ]; then
			sudo cp $system_connections/$network.nmconnection \
                $recipe_data/system-connections
            sudo chown $USER:$USER $recipe_data/system-connections/$network.nmconnection            
		fi
	done

else

sudo cp -r $system_connections $recipe_data
sudo chown -R $USER:$USER $recipe_data/system-connections

fi
