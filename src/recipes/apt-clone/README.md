# Apt clone
This recipe uses the `apt-clone` tool 
<https://packages.ubuntu.com/search?keywords=apt-clone> 
to make a backup of all apt packages installed. It will also create a deb file
for packages that were installed but cannot be found in apt sources.

This recipe will NOT attempt to restore packages, but will instead leave a file 
located at `$HOME/tmp/apt-clone.tar.gz`. You can see a diff between the packages 
installed during backup and after restore by running: 
`apt-clone show-diff $HOME/tmp/apt-clone.tar.gz`.

## [untested] Auto-restore:
You may manually restore packages using: `sudo apt-clone restore $HOME/tmp/apt-clone.tar.gz`. 
If you are using a newer version of your OS, you may use the command: 
`sudo apt-clone restore-new-distro $HOME/tmp/apt-clone.tar.gz`.

It is not recommended to restore packages this way unless you have been diligent 
in uninstalling old or unused packages as this may install unwanted packages in 
your newly restored setup.
