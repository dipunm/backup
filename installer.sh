### TODO build downloader
mkdir -p ~/.backup
cp -r ~/Projects/bakitup/backup/* ~/.backup

BACKUP_USR_ROOT="${BACKUP_USR_ROOT:-$HOME/.backup}"
cat ~/.zshrc | grep BACKUP_USR_ROOT >/dev/null || echo "
# Backup tool.
BACKUP_USR_ROOT=\"$BACKUP_USR_ROOT\"
" >> ~/.zshrc

[ ! -L "/usr/local/bin/mbkp" ] && sudo ln -s "$BACKUP_USR_ROOT/src/main.sh" "/usr/local/bin/mbkp"