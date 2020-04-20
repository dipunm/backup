#!/bin/bash

cp $DIR_STORE/apt-clone.tar.gz $HOME
sudo apt update
sudo apt install apt-clone -y
