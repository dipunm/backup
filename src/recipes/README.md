## Recipes
Each recipe can have one or both of: `backup.sh` and `restore.sh`. These files must be executable bash scripts.

You may also include a `default.conf` which will be copied to a configuration folder for the user to modify. 
It is also useful to create a README.md file explaining what the recipe does.

## Environment variables.
In the backup script, the following variables are available:
- `$DIR_TMP`:     A randomly generated directory which will be deleted after this script ends. Use to store temporary files.
- `$DIR_STORE`:   A private directory to store any files that should be included in the backups.
- `$DIR_RECIPE`:  The path to the folder this script resides in.
- `$SRC_CONFIG`:  The path to the config file. You may need to copy this file into the `$DIR_STORE` directory for use by the restore script

In the restore script, the following variables are available:
- `$DIR_TMP`:     A randomly generated directory which will be deleted after this script ends. Use to store temporary files.
- `$DIR_STORE`:   A private directory with files created by your backup script to use.
- `$DIR_RECIPE`:  The path to the folder this script resides in.

> IMPORTANT: Be careful to exit in your scripts with an appropriate exit code.