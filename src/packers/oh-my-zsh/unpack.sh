#!/bin/bash

. "$DIR_STORE/config"

ask() {
    read -r -p $1 response
    case "$response" in
    [Yy][Ee][Ss]|[Yy])
        return 0
    ;;
    *)
        return 1
    ;;
    esac
}

read -r ZSH < "$DIR_STORE/ZSH"
mkdir -p "$ZSH"
cp -r "$DIR_STORE/omz/." "$ZSH"
cp -r "$DIR_STORE/home/." ~

if ! which zsh >/dev/null; then
    echo "zsh is not installed."
    [ "$auto_install" = "true" ] || ask "Install now? [Y/n]: " && sudo apt install zsh -y
fi

if [ $( basename "$SHELL" ) != "zsh" ]; then
    echo "zsh is not the default shell."
    [ "$auto_change_shell" = "true" ] || ask "Set zsh as your default shell? [Y/n]: " && \
    echo "Changing shell to zsh" && ( chsh -s $(which zsh) || \
    echo "chsh failed. Try again by executing the following command:"$'\n'"chsh -s \$(which zsh)" )
fi
