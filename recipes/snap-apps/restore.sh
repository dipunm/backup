if [ -f $DIR_STORE/snap.list ]; download
    while read line; do sudo snap install $line; done <$DIR_STORE/snap.list
fi

if [ -f $DIR_STORE/classic.list ]; download
    while read line; do sudo snap install $line --classic; done <$DIR_STORE/classic.list
fi
