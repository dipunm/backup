# Backup tool
This tool is designed to make backup and restores easier in linux applications. 
Currently it has been designed for Ubuntu, but hopefully as it gains adoption, it
can become friendly for many other desktop linux distributions.

## Install
```bash
bash <(wget -qO- https://raw.githubusercontent.com/dipunm/backup/master/installer.sh)
```

## Configuration
After installation, you will need to configure the application. 
You can find your configuration files by visiting: `$BACKUP_USR_ROOT/configs`

> TIP: r_*.conf files are recipe specific configs. They will likely have comments that
are useful to read. Also, they may have documentation in 
`$BACKUP_USR_ROOT/recipes/*/README.md`

## Work in progress
see: [TODO](TODO.md)