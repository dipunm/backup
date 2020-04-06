sudo cp -r $DIR_STORE/preferences.d /etc/apt
sudo cp -r $DIR_STORE/sources.list.d /etc/apt
sudo cp -r $DIR_STORE/trusted.gpg.d /etc/apt
sudo cp $DIR_STORE/sources.list /etc/apt
sudo cp $DIR_STORE/trusted.gpg /etc/apt
sudo apt update