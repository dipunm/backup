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

    read -rs -d '' -t 0.1
    read -rsn1 -p "Press any key to continue"$'\n'
fi

sudo apt-get install "${available[@]}" -y
