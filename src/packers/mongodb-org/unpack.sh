#!/bin/bash

ask() {
    read -r -p "$1" response
    case "$response" in
    [Yy][Ee][Ss]|[Yy])
        return 0
    ;;
    *)
        return 1
    ;;
    esac
}

if which mongo; then
    echo "mongo already installed."
else
    wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org

    sudo systemctl daemon-reload
    if ask "Start the mongod service now? [y/N]: "; then
        sudo systemctl start mongod || exit
    fi
    if ask "Enable the mongod service to autostart on boot? [y/N]: "; then
        sudo systemctl enable mongodb || exit
    fi
fi