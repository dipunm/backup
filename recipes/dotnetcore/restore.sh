for i in ${!dotnet_sources[@]};
do
    src=${dotnet_sources[$i]}$tmpd/lib/packages-microsoft-prod.deb
    read -d '' -r -a packages <<< "${dotnet_packages[$i]}";

    wget $src -O $tmpd/lib/packages-microsoft-prod.deb
    sudo dpkg -i $tmpd/lib/packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install apt-transport-https -y
    sudo apt-get update
    sudo apt-get install ${packages[@]} -y

    rm $tmpd/lib/packages-microsoft-prod.deb
done
