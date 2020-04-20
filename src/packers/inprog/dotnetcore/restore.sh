#!/bin/bash

[ -f "$DIR_STORE/dotnetcore.conf" ] && . "$DIR_STORE/dotnetcore.conf"

for i in "${!dotnet_sources[@]}";
do
    src="${dotnet_sources[$i]}"
    read -d '' -r -a packages <<< "${dotnet_packages[$i]}";

    wget "$src" -O "$DIR_TMP/packages-microsoft-prod.deb"
    sudo dpkg -i "$DIR_TMP/packages-microsoft-prod.deb"
    sudo apt-get update
    sudo apt-get install apt-transport-https -y
    sudo apt-get update
    sudo apt-get install "${packages[@]}" -y
done
