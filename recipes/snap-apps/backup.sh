snap list --color=never --unicode=never | awk '$6!~/classic/ { print $1 }' > $recipe_data/snap.list
snap list --color=never --unicode=never | awk '$6/classic/ { print $1 }' > $recipe_data/classic.list
