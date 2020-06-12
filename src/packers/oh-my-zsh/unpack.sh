#!/bin/bash

. "$DIR_STORE/config"

read -r ZSH < "$DIR_STORE/ZSH"
mkdir -p "$ZSH"
cp -r "$DIR_STORE/omz/." "$ZSH"
cp -r "$DIR_STORE/home/." ~

if ! which zsh >/dev/null; then
    echo "zsh is not installed."
    [ "$auto_install" = "true" ] || ask.sh -y "Install now?" && apt-install.sh zsh
fi

if [ $( basename "$SHELL" ) != "zsh" ]; then
    echo "zsh is not the default shell."
    [ "$auto_change_shell" = "true" ] || ask.sh -y "Set zsh as your default shell?" && \
    echo "Changing shell to zsh" && ( chsh -s $(which zsh) || \
    echo "chsh failed. Try again by executing the following command:"$'\n'"chsh -s \$(which zsh)" )
fi
