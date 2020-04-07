#!/bin/bash

### TODO build downloader
BACKUP_USR_ROOT="${BACKUP_USR_ROOT:-"$HOME/.backup"}"
SOURCE="$HOME/Projects/backup"
SCRIPT="
# Backup tool.
BACKUP_USR_ROOT=\"$BACKUP_USR_ROOT\"
"

pause_continue() {
    read -rsn1 -p "Press any key to continue..."$'\n'
}

RCs=( '' ~/.zshrc ~/.bashrc )
case "$(basename "$SHELL")" in
    bash)
        SHELLNAME="bash"
        option=2
    ;;
    zsh)
        SHELLNAME="zsh"
        option=1
    ;;
    *)
        SHELLNAME="unknown"
        option=0
    ;;
esac

echo "
#########################################
## Hi! Thanks for installing MyBackup. ##
#########################################

==> MyBackup will be installed to '$BACKUP_USR_ROOT'.
" && pause_continue

mkdir -p "$BACKUP_USR_ROOT" && cp -r "$SOURCE"/* "$BACKUP_USR_ROOT" && echo "
Files installed successfully.
";

echo "Awesome! We will need to install some environment variables to your 
shell profile and install the mbkp command.

==> We detected that your default shell is $SHELLNAME
" && pause_continue && echo;

read -r -p "Which one of these profile files should we install to?
0: None
1: ~/.zshrc
2: ~/.bashrc

enter a number [$option]: " choice

echo; # empty line

RC="${RCs["${choice:-"$option"}"]}"
[ -n "$RC" ] && echo -n "Installing to '$RC'. "
[ -z "$RC" ] && echo -n "Ok, we won't modify any files. "

echo; # empty line

if [ -n "$RC" ] && [ -f "$RC" ]; then
    if cat "$RC" | grep BACKUP_USR_ROOT >/dev/null; then
        echo "
==> A previous installation was found in '$RC'. Mo changes were made."
    else
        echo "$SCRIPT" >> "$RC" && echo "==> Installation to '$RC' completed successfully."
    fi
elif [ -n "$RC" ]; then
    echo "Unable to find profile file: '$RC'."
    RC=''
fi

echo;

echo "Installing the mbkp binary..."
if [ ! -L "/usr/local/bin/mbkp" ]; then
    sudo ln -sf "$BACKUP_USR_ROOT/src/main.sh" "/usr/local/bin/mbkp" && echo "==> Congrats! You should now be able to use the mbkp command."
else
    echo "
==> mbkp binary already exists.
"
fi

[ -z $RC ] && echo " 
==> IMPORTANT: Please manually add the following to your shell profile file:
$SCRIPT
==> Thankyou
"
echo "Please confirm the installation by running: 
mbkp --version"
echo;