if [ -f $recipe_data/snap.list ]; download
    while read line; do sudo snap install $line; done <$recipe_data/snap.list
fi

if [ -f $recipe_data/classic.list ]; download
    while read line; do sudo snap install $line --classic; done <$recipe_data/classic.list
fi
