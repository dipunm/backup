### TODO build downloader
BACKUP_USR_ROOT="${BACKUP_USR_ROOT:-"$HOME/.backup"}"
SOURCE="$HOME/Projects/backup"

mkdir -p "$BACKUP_USR_ROOT"
cp -r "$SOURCE"/* "$BACKUP_USR_ROOT"

RC=''
case "$SHELL" in
    /usr/bin/bash|/bin/bash)
        RC=~/.bashrc
    ;;
    /usr/bin/zsh|bin/zsh)
        RC=~/.zshrc
    ;;
esac

SCRIPT="
# Backup tool.
BACKUP_USR_ROOT=\"$BACKUP_USR_ROOT\"
"

if [ -n "$RC" ]; then
    echo "your default shell is $SHELL. Adding configuration to $RC"
    cat "$RC" | grep BACKUP_USR_ROOT >/dev/null || echo "$SCRIPT" >> "$RC"
else
    echo "Unable to determine your default shell. 
Please manually add the following to your shell's rc file:
$SCRIPT"
fi

[ ! -L "/usr/local/bin/mbkp" ] && sudo ln -sf "$BACKUP_USR_ROOT/src/main.sh" "/usr/local/bin/mbkp" || true