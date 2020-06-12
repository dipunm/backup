#!/bin/bash

read -r path < "$DIR_STORE/path"
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
        curl -L -o- $FILE > $DIR_TMP/onedriver_amd64.deb || exit
    elif which wget >/dev/null; then
        wget -qO- $FILE > $DIR_TMP/onedriver_amd64.deb || exit
    else
        >&2 echo $'ERROR: Unable to download onedriver, please install curl or wget and then run:\n\n    backup restore <file> -p onedriver\n' 
        exit 1
    fi

    apt-install.sh libwebkit2gtk-4.0-dev || exit
    gdebi.sh "$DIR_TMP/onedriver_amd64.deb" || exit

fi

: ${MOUNTPOINT:="/home/$USER/OneDrive"}
mkdir -p $MOUNTPOINT
export SERVICE_NAME=$(systemd-escape --template onedriver@.service $MOUNTPOINT)

mkdir -p ~/.cache
cp -r "$DIR_STORE/.cache/onedriver" ~/.cache

# mount onedrive
systemctl --user daemon-reload || exit
systemctl --user start $SERVICE_NAME || exit

# mount onedrive on login
systemctl --user enable $SERVICE_NAME || exit

# check onedriver's logs
echo "To diagnose any issues, you can check the logs by running the following command:

    journalctl --user -u $SERVICE_NAME
"