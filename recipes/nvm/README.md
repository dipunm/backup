# NVM
This recipe allows you to restore NVM on a new installation without needing to backup 
the .nvm folder. The .nvm folder contains all the versions of node installed on your 
machine as well as its global npm packages and other things like caches. This recipe
will record the versions of node installed and any aliases that you have set up only.

Globally installed npm packages will need to  be re-installed after restore.

> **Note:** If you backup the .nvm folder, you do not need this recipe as the files are 
already part of your backup.

## Configuration
file: `$BACKUP_USR_ROOT/configs/nvm.conf`
```bash
# Set the nvm install directory:
NVM_DIR=/home/$USER/.nvm
```