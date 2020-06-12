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

### Backup your desktop
```bash
mbkp backup -o /path/to/folder
```

The `-o` argument is optional. By default, the backup will be placed in your home directory. \
The output will be a `.tar.gz` file with a timestamped name.

### Restore your backup
```bash
mbkp restore <archive>
```

Restoring is an interactive process. 
1. You will first be presented with a list of **parcels** that will be restored. You may exit by sending a SIGINT signal (press `CTRL + C`), or you can press any key to continue. If you wish to run only a subset of parcels, see [partial restore](#partial-restore)
2. Each parcel will restore itself, it may require user input as it executes privellaged actions and it may also ask for input as it restores, giving you control over its actions.
3. At the end, the application will list any parcels that had errors during the restore process. The backup is a simple archive, you may want to follow the [manual restore](#manual-restore) section to complete the restoration.
3. On exit, the application will clean up temporary files. If the application was terminated early, the application will still attempt to clean up, but certain kill commands, or issuing SIGINT multiple times may cause the clean up to fail. You can find the temporary files in `~/.backup/backupXXXXXX.tmp` (where XXX represents a unique number).



### Partial restore
You may decide to restore only part of the backup by naming the parcels you'd like to restore:
```bash
mbkp restore <archive> -p parcel-1 parcel-2 ...
```

### Manual restore
If there is a problem with the restore script, you may wish to manually restore the package yourself. The backup archive has a structure as follows:

- `/order`: A file that suggests the order in which the parcels should be unpacked.
- `/shared`: A set of executable scripts that are typically used by the parcels to ensure a consistent experience where possible.
- `/parcels`: This is where each parcel is stored. Each parcel is contained within its own directory.

Within each parcel directory:
- `/store`: This is where the files to restore are kept. In some cases, such as with the `snap-apps` parcel, it stores configuration or manifest files, which influence what actions to take.
- `/scripts`: The scripts folder contains the scripts of the packer at the time when the backup was made. This ensures that future potential breaking changes will not make the restore script to fail. (these files are useful to understand how each parcel works, but in the case where a restore might fail, you'd typically only need to care about `unpack.sh`)

## Configuration
In the `~/.backup/config` folder, there are typically 2 files: `main.conf` and `main.example.conf`. You may use the example file to see what configuration options are availabile to you. The installer/upgrader will keep the example file updated, but will not touch the `main.conf` file.

## Updating
To update, run the following command:
```bash
~/.backup/upgrade.sh
```

Note: The `devupgrade.sh` script is a development tool. Running this script will install an experimental/potentially broken build of the application.

## Work in progress
see: [TODO](TODO.md)
