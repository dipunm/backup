# Apt sources
This recipe will backup and restore apt-sources and apt-keys.

The restore process will replace existing `sources.list` and `trusted.gpg` 
files, as well as any duplicately named files in `sources.list.d`, 
`preferences.d` and `trusted.gpg.d` (all found in `/etc/apt`). This may have 
unwanted side effects, therefore during the restore process, a backup of the 
original files will be made in `$HOME/tmp/apt-backup`. After a restore, you 
may remove these files after verifying that the restore was successful.