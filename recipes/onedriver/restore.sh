get_deb_url() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"browser_download_url":' |
    grep "https" |
    grep "amd64.deb" |                                            # Get tag line
    sed -E 's/.*"([^"]+amd64.deb)".*/\1/'                         # Pluck JSON value
}

FILE=$(get_deb_url jstaf/onedriver)

if which curl >/dev/null; then
    curl -L -o- $FILE > $tmpd/onedriver_amd64.deb
elif which wget >/dev/null; then
    wget -qO- $FILE > $tmpd/onedriver_amd64.deb
else
    >&2 echo $'ERROR: Unable to download onedriver, please install curl or wget and then run:\n\n    backup restore --retry onedriver\n' 
    return
fi

if ! (which gdebi>dev/null) then
    echo "installing gdebi to enable installing deb files."
    sudo apt install gdebi
fi
sudo gdebi $tmpd/onedriver_amd64.deb
