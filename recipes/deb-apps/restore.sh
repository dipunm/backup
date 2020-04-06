which gdebi > /dev/null || sudo apt install gdebi
for deb in ${debs[@]}
do

    if [ -f $deb ]; then
        sudo gdebi $deb
    elif [ -d $deb ]; then
        for sub_deb in $deb/*.deb
        do
            sudo gdebi $sub_deb
        done
    fi
done