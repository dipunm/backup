#!/bin/bash
{

if [ -z $BACKUP_USR_ROOT ]; then
    non_standard_install="true"
    BACKUP_USR_ROOT="$HOME/.backup"
fi

SCRIPT="
# Backup tool.
export BACKUP_USR_ROOT=\"$(echo "$BACKUP_USR_ROOT" | sed "s%^$HOME%\$HOME%")\"
"

pause_continue() {
    read -rsn1 -p "Press any key to continue..."$'\n'
}

copy_files() {
    hash="$(date '+%s')"
    mkdir -p "$BACKUP_USR_ROOT/configs"
    cp -n "$SOURCE/configs/main.conf" "$BACKUP_USR_ROOT/configs"
    cp "$SOURCE/configs/main.example.conf" "$BACKUP_USR_ROOT/configs"

    rm -rf "$BACKUP_USR_ROOT/src"
    cp -pr "$SOURCE/src" "$BACKUP_USR_ROOT"
    cp -p "$SOURCE/README.md" "$BACKUP_USR_ROOT"
    cp -p "$SOURCE/upgrade.sh" "$BACKUP_USR_ROOT"
    cp -p "$SOURCE/devupgrade.sh" "$BACKUP_USR_ROOT"
    cp -p "$SOURCE/installer.sh" "$BACKUP_USR_ROOT"
    cp -p "$SOURCE/LICENSE" "$BACKUP_USR_ROOT"
}

download() {
    branch=${1-"master"}
    # Downloader downloads from branch: master by default
    tmp_dir=".tmp_$(date '+%s')"
    tmp_dir=~/"$tmp_dir"
    mkdir -p $tmp_dir
    trap "rm -rf $tmp_dir" EXIT

    wget -O "$tmp_dir/backup-$branch.tar.gz" "https://github.com/dipunm/backup/archive/$branch.tar.gz" && \
    tar -xzf "$tmp_dir/backup-$branch.tar.gz"  -C "$tmp_dir" "backup-$branch"
    SOURCE="$tmp_dir/backup-$branch"
    # End Downloader
}

main() {

download

echo "
#########################################
## Hi! Thanks for installing MyBackup. ##
#########################################

==> MyBackup will be installed to '$BACKUP_USR_ROOT'.
" && pause_continue || exit 0

mkdir -p "$BACKUP_USR_ROOT" && copy_files && echo "
Files installed successfully.
"

echo;


if [ ! -L ~/.local/bin/mbkp ]; then
    rm -rf ~/.local/bin/mbkp;
    mkdir -p ~/.local/bin
    echo "Installing the mbkp executable in ~/.local/bin"
    sudo ln -sf "$BACKUP_USR_ROOT/src/main.sh" ~/.local/bin/mbkp && \
    echo "==> Congrats! You should now be able to use the mbkp command." || exit 1
else
    echo "
==> mbkp executable already exists.
"
fi


if [ "$non_standard_install" = "true" ]; then

echo " 
==> IMPORTANT: Please manually add the following to your shell profile file:
$SCRIPT
==> Thankyou
"

fi

echo "

Please confirm the installation by running: 
mbkp --version

You may need to add ~/.local/bin to your PATH variable if it does not work.
"

}


if [ "$BACKUP_INSTALL_OVERRIDE" != "don't install" ]; then
    main
fi

}
