#!/bin/bash

sudo apt update
sudo apt install zsh
echo "Changing the default shell to zsh."
chsh -s $(which zsh)

echo $'The default shell will not take effect yet.
You must log out and back in to see zsh in the terminal by default.
Until then, you may enter the zsh command to enter the new shell in your terminal'
