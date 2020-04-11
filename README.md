# Backup tool
This tool is designed to make backup and restores easier in linux applications. 
Currently it has been designed for Ubuntu, but hopefully as it gains adoption, it
can become friendly for many other desktop linux distributions.

## Install
```bash
bash <(wget -qO- https://raw.githubusercontent.com/dipunm/backup/master/installer.sh)
```

## Philosophy
Learning what files to backup on a desktop linux environment is tricky because a 
typical installation is usually not quite ready (... for me). After playing with 
Ubuntu, I quickly realised that:

1. I can easily break something and not know if I have fixed it properly or not.
2. Figuring out what software I need and installing it takes time.
3. Applications are typically distributed in many different package formats.

Most backup tools give you a way to specify what files to backup, but don't provide 
any guidance on what files you should backup. A lot of unneccesary files exist in 
your home directory, and a few settings and items of interest will exist outside 
your home directory.

I really enjoyed the simplicity of setting up and using 
[oh-my-zsh](https://ohmyz.sh/) and I felt like creating something similar for 
backups; where users can collaboratively create and share recipes for backing up 
their favourite application configs.

The application serves three main functions:

### 1. Backing up only the files you care about in the home directory
A lot of applications store settings in your home directory. You may even have 
folders that are typically full of unhelpful files (such as the ~/Downloads 
directory). Many applications store caches and temporary files that take up 
both time and space when backing up your installation.

This application aims to make backups more thoughtful by providing a way to
include specific files and folders. You could backup your whole home directory 
and call it a day, but then this program is likely not useful for you. Also, 
when you restore your backup to a new system, there will likely be a lot of 
unhelpful junk left over.

To encourage backing up only useful files, the application allows you to 
split your list of files to backup into multiple files that can be shared. 
The hope is that over time, there will be an application specific file such as 
`firefox.list` that ensures that people's profiles and settings are backed up 
with very little effort, and nothing more is carried over (eg. caches).

### 2. Restoring applications
Backing up and restoring configuration and state files for applications that 
are not installed is not very useful. Therefore, a second part of the 
applications responsibility is to restore the operating system back to its 
useful state with all the important applications re-installed, and none of 
the unimportant applications that were installed once and never uninstalled.

The application introduces a concept called recipes. There are some basic 
recipes that install apt and snap packages, and this is useful for peace of 
mind; knowing that if you need to restore onto a fresh installation of linux, 
you won't need to spend hours or even days re-installing all your 
applications.

Unfortunately, a lot of applications must be built from source, or using 
different techniques. Some software requires following a unique set of 
instructions. My hope is that some of the more popular tools and 
applications will be turned into recipes and kept up to date by users who 
use the applications. Now we can have even more peace of mind, that we can 
restore even more applications that would previously have to be installed 
manually as they are needed, slowing your productivity.

### 3. Restoring OS and administrator settings
Some things are useful to backup, but do not live within your home folder. 
Recipes can be used to backup these things and restore them. Things like 
wifi settings and services can be restored between installations.

Across each of these functions, the main philosophy is to ensure that 
backups: 
1. Are not bloated with unneccesary files
2. Are mindfully crafted so that only things that matter are restored to a 
new system
3. Are as useful as possible, not being constrained to your home folder
4. Are convenient and take advantage of community driven recipes

## Useful files and folders
A typical installation will place the backup application in `~/.backup`. 
This folder will be referred to as `$BACKUP_USR_ROOT`. Your home directory 
will be referred to as `$HOME`.

### $BACKUP_USR_ROOT/configs/main.conf
Here you will be able to configure the main application. For now, we can 
only specify which recipes we'd like to enable. This is similar to the 
concept of plugins and custom plugins in `oh-my-zsh`.

### $BACKUP_USR_ROOT/configs/backup.list
This file contains a list of files and folders (relative to `$HOME`) to 
include in the backup process. Each entry is separated by a new line, and
the `#` symbol can be used to add comments. Empty lines are allowed and 
will simply be ignored. This file is given directly to `rsync`. For more 
information, you can read about the `--include-from=` flag of `rsync`.

### $BACKUP_USR_ROOT/configs/backup.list.d
Files in this directory with a `.list` extension will be appended to the 
`backup.list` file described above before being passed to `rsync`. This
allows us to create isolated files that can be shared between users.

### $BACKUP_USR_ROOT/recipes/
In this folder, each folder represents a recipe and its directory name 
will be used as the name of the recipe. Each recipe will contain either 
a `backup.sh` file, a `restore.sh` file, or both. These files are 
interpreted by bash during backup and restore respectively.

### $HOME/tmp/
After a successful restore, a lot of recipes will place temporarily useful 
files in `$HOME/tmp`. These files may be useful to diagnose and repair any 
problems remaining or caused by the restore. The files left here are created 
by the recipes themselves, so it is not possible to know what files to 
expect here, but the files here can be safely removed at your leisure 
without causing harm to your system.
