[ -d "/etc/apt/preferences.d" ] && cp -r /etc/apt/preferences.d $DIR_STORE
[ -d "/etc/apt/sources.list.d" ] && cp -r /etc/apt/sources.list.d $DIR_STORE
[ -d "/etc/apt/trusted.gpg.d" ] && cp -r /etc/apt/trusted.gpg.d $DIR_STORE
[ -f "/etc/apt/sources.list" ] && cp /etc/apt/sources.list $DIR_STORE
[ -f "/etc/apt/trusted.gpg" ] && cp /etc/apt/trusted.gpg $DIR_STORE