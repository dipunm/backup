for i in ${!dotnet_sources[@]};
do
    src=${dotnet_sources[$i]}$DIR_TMP/lib/packages-microsoft-prod.deb
    read -d '' -r -a packages <<< "${dotnet_packages[$i]}";

    wget $src -O $DIR_TMP/lib/packages-microsoft-prod.deb
    sudo dpkg -i $DIR_TMP/lib/packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install apt-transport-https -y
    sudo apt-get update
    sudo apt-get install ${packages[@]} -y

    rm $DIR_TMP/lib/packages-microsoft-prod.deb
done
