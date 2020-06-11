src="https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb"
to_install=( $( cat "$DIR_STORE/installed" ) )

if ! which dotnet >/dev/null; then
    wget "$src" -O "$DIR_TMP/packages-microsoft-prod.deb"
    sudo dpkg -i "$DIR_TMP/packages-microsoft-prod.deb"
    sudo apt-get update
    sudo apt-get install apt-transport-https -y
    sudo apt-get update
fi

available=( $( { apt-cache pkgnames && echo "${to_install[@]}" | tr ' ' '\n'; } | sort | uniq -d ) )
unavailable=( $( echo "${available[@]} ${to_install[@]}" | tr ' ' '\n' | sort | uniq -u ) )

if [ "${#unavailable[@]}" -gt "0" ]; then
    echo "The following packages will not be installed:"
    for pkg in "${unavailable[@]}"; do
        echo "> $pkg"
    done
    echo; echo "This can happen for old, unsupported versions of dotnetcore.\
    You will need to install these manually by finding sources online."$'\n'

    read -rs -d '' -t 0.1
fi

echo "The following package will be installed: ${available[@]}"
pause.sh
sudo apt-get install "${available[@]}" -y
