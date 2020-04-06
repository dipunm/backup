backup_recipes() {
	for recipe in "${RECIPES[@]}"
    do
        if [ ! -d "$dir_recipes_src/$recipe" ]; then
			echo_err "recipe not found: '$recipe'."
			ask -n "abort?" && exit 1
            continue
        fi

        [ ! -f "$dir_recipes_src/$recipe/backup.sh" ] && continue

		tput sc
		echo "$recipe:"

        (
            export DIR_STORE="$dir_recipes_store/$recipe"
            export DIR_TMP=$dir_tmp
			export DIR_RECIPE="$dir_recipes_src/$recipe"
			
        	mkdir -p $DIR_STORE

			export SRC_CONFIG="$dir_recipes_config/r_${recipe}.conf"
			if [ -f "$SRC_CONFIG" ]; then
				. "$SRC_CONFIG" || exit
			else
				unset SRC_CONFIG
			fi
			$DIR_RECIPE/backup.sh
		)
		local subsh_code="$?"
		tput rc
		tput ed

		[ "$subsh_code" == "0" ] && echo "$recipe: completed successfully." && continue
		continue_prompt "$recipe: Exited with code $?."
    done
}

build_whitelist() {
	local source="$1"
	local dest="$2"
	touch $dest
	cat $source > $dest
	for file in "$source.d/"*.list
	do
		echo $'\n'"$(cat $file)" >> $dest
	done
  	echo $'\n'"$(realpath $dir_recipes_src --relative-to=$HOME)" >> $dest
  	echo $'\n'"$(realpath $dir_recipes_store --relative-to=$HOME)" >> $dest
	echo $'\n'"$(realpath $dir_recipes_config --relative-to=$HOME)" >> $dest
	echo $'\n'"$(realpath $dir_config --relative-to=$HOME)" >> $dest
	sort -o $dest $dest
}

backup() {
    assert_file "$dir_config/files-from.list" 

	echo "# Collecting recipe data"
    backup_recipes

	echo $'\n'"# Backing up files"
	fpath_whitelist="$dir_tmp/whitelist.list"
	build_whitelist "$dir_config/files-from.list" "$fpath_whitelist"
	local name_tmp=$(date +'%Y-%m-%d-%H%M%S')
	local dir_tmp_output="$dir_tmp/$name_tmp"
	
	echo rsync $(realpath $dir_tmp --relative-to=$HOME)
	rsync -ar --info=progress2 \
		--files-from="$fpath_whitelist" \
		--exclude="$(realpath $dir_tmp --relative-to=$HOME)" \
		"$HOME" "$dir_tmp_output/"

	echo $'\n'"# Creating archive"
	pushd $dir_tmp_output
	echo "output: $DIR_OUTPUT/$name_tmp.tar.gz"
	tar -czf "$DIR_OUTPUT/$name_tmp.tar.gz" .
	popd

	echo "complete."
}