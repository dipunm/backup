BACKUP_USR_ROOT="${BACKUP_USR_ROOT:-"$HOME/.backup"}"
SOURCE="$HOME/Projects/bakitup/backup"

[ ! -d BACKUP_USR_ROOT ] && echo "backup root not found at: $BACKUP_USR_ROOT" && exit 1
rm -rf $BACKUP_USR_ROOT/src
cp -r $SOURCE/src $BACKUP_USR_ROOT

for recipe in $SOURCE/recipes
do (
    name=$(basename $recipes)
    if [ -d $recipe ]; then
        rm -rf $recipe
        cp -r $BACKUP_USR_ROOT/recipes/$name
    else 
        cp -r $SOURCE/recipes/$name $BACKUP_USR_ROOT/recipes
    fi
) done

cat ~/.zshrc | grep BACKUP_USR_ROOT >/dev/null || echo "
# Backup tool.
BACKUP_USR_ROOT=\"$BACKUP_USR_ROOT\"
" >> ~/.zshrc

[ ! -L "/usr/local/bin/mbkp" ] && sudo ln -sf "$BACKUP_USR_ROOT/src/main.sh" "/usr/local/bin/mbkp"
