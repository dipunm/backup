#!/bin/bash

latest_supported_lts_codename='bionic'

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

docker_source_exists() {
    apt-cache policy | grep https://download.docker.com/linux/ubuntu >/dev/null
}

if ! docker_source_exists; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -

    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" | sudo tee /etc/apt/sources.list.d/docker.list

    sudo echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $latest_supported_lts_codename stable" >> /etc/apt/sources.list.d/docker.list
fi

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

echo "

IMPORTANT: You will need to log out before you use docker in order for permissions to kick in.
"