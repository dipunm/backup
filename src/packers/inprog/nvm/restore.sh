#!/bin/bash

[ -f "$DIR_STORE/nvm.conf" ] && . "$DIR_STORE/nvm.conf"

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

VERSION=$(get_latest_release nvm-sh/nvm)

if which curl >/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh | bash
elif which wget >/dev/null; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
else
    >&2 echo $'ERROR: Unable to download nvm, please install curl or wget and then run:\n\n    backup restore ARCHIVE -r nvm\n'
    return
fi

nvm_default_install_dir() {
  [ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm"
}
: ${NVM_DIR:=$(nvm_default_install_dir)}
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -d $DIR_STORE/alias ]; then
    cp -r $DIR_STORE/alias $NVM_DIR
fi

if [ -f $DIR_STORE/node-versions.list ]; then
    while read line; do nvm install $line; done <$DIR_STORE/node-versions.list
fi
