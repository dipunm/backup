# Gnome network settings
Backs up your saved network connections.

> WARNING: This will likely store your wifi passwords in plain text in your backup 
file. Be sure to store your backups sensibly.

## Configuration
You may specify a whitelist of networks to backup. The network name will be case sensitive.

file: `$BACKUP_USR_ROOT/configs/r_gnome-network-settings.conf`
```bash
# the names below are names of networks that I'd like to save
backup_networks=( HomeWifi1 HomeWifi2 FamilyWifi )
```