# apt update and upgrade
This recipe should usually be last. It will ensure that apt is updated with 
the new sources and will upgrade all installed packages. This recipe will also
run `sudo apt autoremove` to cleanup unused apt packages.

This package does not have any backup procedures.