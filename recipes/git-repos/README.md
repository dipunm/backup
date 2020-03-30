# Git repos
This recipe will create a record the paths to all folders which are git 
repositories recursively from your home directory. It does not save any
information about the git repository, only the folder name.

This is useful to developers who may have many git repositories checked 
out, who do not wish to backup those repositories due to large sizes, but 
do want something to remind them what repositories to restore.

After restoring, you will have a file located at `$HOME/tmp/git-repos.list` 
with a list of absolute paths to repositories found during backup. You may 
refer to this file and remove it when you are done.

## Configuration
You can limit which folders to scan for git repositories. This is useful 
because some applications install git repositories in your home directory 
which you probably do not care about.

file: `$BACKUP_USR_ROOT/configs/git-repos.conf`
```bash
source_dirs=( /home/$USER/projects )
```