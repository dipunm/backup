#!/bin/bash

if ({ apt-mark showmanual; apt-mark showauto } | grep '^mongodb-org$'); then
    echo "mongo already installed."
else
    wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
    apt-install.sh mongodb-org
fi

sudo systemctl daemon-reload
if ask.sh -n "Start the mongod service now?"; then
    sudo systemctl start mongod || exit
fi
if ask.sh -n "Enable the mongod service to autostart on boot?"; then
    sudo systemctl enable mongod || exit
fi
