#Snap apps
Creates a list of installed snaps during backup and uses `sudo snap install` to 
reinstall them during a restore.

It also keeps track of which packages were classic packages and uses the appropriate 
install command: `sudo snap install ... --classic`.