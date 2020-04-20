#!/bin/bash

read -r "$DIR_STORE/path" path
if [ -n "$path" ]; then
    # eval ensures variables get expanded.
    export MOUNTPOINT="$(eval echo "$path")"
fi

get_deb_url() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"browser_download_url":' |
    grep "https" |
    grep "amd64.deb" |                                            # Get tag line
    sed -E 's/.*"([^"]+amd64.deb)".*/\1/'                         # Pluck JSON value
}

FILE=$(get_deb_url jstaf/onedriver)

if ! which onedriver >/dev/null; then

    if which curl >/dev/null; then
        curl -L -o- $FILE > $DIR_TMP/onedriver_amd64.deb
    elif which wget >/dev/null; then
        wget -qO- $FILE > $DIR_TMP/onedriver_amd64.deb
    else
        >&2 echo $'ERROR: Unable to download onedriver, please install curl or wget and then run:\n\n    backup restore --retry onedriver\n' 
        return
    fi

    if ! (which gdebi>dev/null) then
        echo "installing gdebi to enable installing deb files."
        sudo apt install gdebi
    fi

    sudo apt install libwebkit2gtk-4.0-dev
    sudo gdebi $DIR_TMP/onedriver_amd64.deb

fi

: ${MOUNTPOINT:="/home/$USER/OneDrive"}
mkdir -p $MOUNTPOINT
export SERVICE_NAME=$(systemd-escape --template onedriver@.service $MOUNTPOINT)

if [ -f "$DIR_STORE/auth_tokens.json" ]; then
    mkdir -p ~/.cache/onedriver
    cp "$DIR_STORE/auth_tokens.json" ~/.cache/onedriver
fi

# mount onedrive
systemctl --user daemon-reload
systemctl --user start $SERVICE_NAME

# mount onedrive on login
systemctl --user enable $SERVICE_NAME

# check onedriver's logs
echo "To diagnose any issues, you can check the logs by running the following command:

    journalctl --user -u $SERVICE_NAME
"