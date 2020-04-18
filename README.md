# Backup tool
This tool is designed to make backup and restores easier in linux applications. 
Currently it has been designed for Ubuntu, but hopefully as it gains adoption, it
can become friendly for many other desktop linux distributions. Contributions are welcome.

## Install
```bash
bash <(wget -qO- https://raw.githubusercontent.com/dipunm/backup/master/installer.sh)
```

## Usage
Once installed, you should immediately be able to call `mbkp`. Executing it without any arguments will provide details of the API.

The executable is installed to `$BACKUP_USR_ROOT/src/main.sh` but symlinked from `/usr/local/bin/mbkp`.
By default, `$BACKUP_USR_ROOT` = `~/.backup`.

## Configuration
There is currently no configuration available. This package will autodetect what to pack and unpack.

You can specify a whitelist of parcels to unpack when restoring. Run `mbkp --help` for details.

## Work in progress
see: [TODO](TODO.md)
