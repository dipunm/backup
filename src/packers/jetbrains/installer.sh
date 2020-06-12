#!/bin/bash
# original-source: https://breandan.net/2014/08/18/shell-script/

CODE="$1"

# Prompt for edition
while true; do
   [ -z "$CODE" ] && read -p "Please select from one of the following choices:
   [1] IntelliJ IDEA Community Edition
   [2] IntelliJ IDEA Ultimate Edition
   [3] PyCharm Community Edition
   [4] PyCharm Professional Edition
   [5] CLion
   [6] WebStorm
   [7] RubyMine
   [8] PhpStorm
   [9] DataGrip
   [10] Rider
  > " CODE
   case "${CODE}" in
       IIC | 1 ) CODE=IIC; IDE=idea; break;;
       IIU | 2 ) CODE=IIU; IDE=idea; break;;
       PCC | 3 ) CODE=PCC; IDE=pycharm; break;;
       PCP | 4 ) CODE=PCP; IDE=pycharm; break;;
       CL | 5 ) CODE=CL;  IDE=clion; break;;
       WS | 6 ) CODE=WS;  IDE=webstorm; break;;
       RM | 7 ) CODE=RM;  IDE=rubymine; break;;
       PS | 8 ) CODE=PS;  IDE=phpstorm; break;;
       DG | 9 ) CODE=DG;  IDE=datagrip; break;;
       RD | 10 ) CODE=RD;  IDE=rider; break;;
   esac
done

echo "Installing $IDE..."

# Prepend base URL for download
URL="https://data.services.jetbrains.com/products/download?platform=linux&code=$CODE"

# Get location header for file URL
HEADERS=$(wget -qS --max-redirect 0 --spider "$URL" 2>&1)
LOCATION=$(echo "$HEADERS" | tac | grep -m 1 "Location: ")
FILE_URL=$(echo "$LOCATION" | sed 's/.*Location: //')
VERSION=$(echo "$FILE_URL" | sed -En 's/.*\/(.*).tar.gz/\1/p')
echo "File to be downloaded: $FILE_URL"
echo "Latest stable version: $VERSION"
[ -z "$VERSION" ] && echo "Version header not found. Exiting." && exit 1;

# Set install directory
INSTALL_DIR="/opt/$VERSION"

# Check if latest version has been installed
if [ -d "$INSTALL_DIR" ]; then
   echo "Found an existing install directory: $INSTALL_DIR"
   echo "$VERSION may have previously been installed."
   while true; do
       read -p "Would you like to reinstall? (Y/N) > " REPLY
       case $REPLY in
           [yY] ) echo "Reinstalling $VERSION..."; break;;
           [nN] ) echo "Aborted install."; exit 0; break;;
       esac
   done
fi

# Set download directory
DEST_DIR=$(mktemp)

# Download binary
echo "Downloading $VERSION from $FILE_URL to $DEST_DIR"
wget -cO ${DEST_DIR} ${FILE_URL} --read-timeout=5 --tries=0
echo "Download complete."

# Overwrite installation directory if it exists
if [ -d "$INSTALL_DIR" ]; then
   echo "Removing existing installation in $INSTALL_DIR"
   rm -rf ${INSTALL_DIR}
fi

# Untar file
if mkdir -p ${INSTALL_DIR}; then
   echo "Extracting $DEST_DIR to $INSTALL_DIR"
   tar -xzf ${DEST_DIR} -C ${INSTALL_DIR} --strip-components=1
fi

# Grab executable folder
BIN=${INSTALL_DIR}/bin

# Add permissions to install directory
echo "Adding permissions to $INSTALL_DIR"
chmod -R +rwx ${INSTALL_DIR}

# Enable to add desktop shortcut
DESK=/usr/share/applications/${IDE}.desktop
echo -e "[Desktop Entry]\nEncoding=UTF-8\nName=${IDE}\nComment=${IDE}\nExec=${BIN}/${IDE}.sh\nIcon=${BIN}/${IDE}.png\nTerminal=false\nStartupNotify=true\nType=Application" > ${DESK}

# Create symlink entry
TARGET=${BIN}/${IDE}.sh
echo "Placing symbolic link to $TARGET in /usr/local/bin/"
ln -sf ${TARGET} /usr/local/bin/${IDE}
