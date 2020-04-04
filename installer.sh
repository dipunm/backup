### TODO build downloader
BACKUP_USR_ROOT="${BACKUP_USR_ROOT:-"$HOME/.backup"}"
SOURCE="$HOME/Projects/bakitup/backup"

mkdir -p $BACKUP_USR_ROOT
cp -r $SOURCE/* $BACKUP_USR_ROOT

cat ~/.zshrc | grep BACKUP_USR_ROOT >/dev/null || echo "
# Backup tool.
BACKUP_USR_ROOT=\"$BACKUP_USR_ROOT\"
" >> ~/.zshrc

[ ! -L "/usr/local/bin/mbkp" ] && sudo ln -sf "$BACKUP_USR_ROOT/src/main.sh" "/usr/local/bin/mbkp"