: ${system_connections:="/etc/NetworkManager/system-connections"}

sudo cp -r $recipe_data/system_connections $(dirname $system_connections)
sudo chown -R root:root $system_connections
