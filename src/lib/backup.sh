ask_abort() {
    [ -n "$1" ] && echo "$1"
    read -r -p "abort? [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY])
            exit 1
            ;;
    esac
}

backup_recipes() {
	for recipe in "${RECIPES[@]}"
    do
        if [ ! -d "$dir_recipes_src/$recipe" ]; then
            ask_abort "recipe not found: '$recipe'."
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
  	echo $'\n'"$(realpath $BACKUP_USR_ROOT --relative-to=$HOME)" >> $dest
	sort -o $dest $dest
}

backup() {
    assert_file "$dir_config/files-from.list" 

	mk_dir_tmp
	trap 'rm_dir_tmp && rm -rf $dir_recipes_store' EXIT

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

	rm_dir_tmp
	echo "complete."

	exit
	# Create a concatenated list of files to copy
	echo "Building list of files to copy..."
	touch $tmpd/$files_from_file
	cat $dir_config/$files_from_file > $tmpd/$files_from_file
	for file in $dir_config/$files_from_file.d/*.list
	do
		echo $'\n'"$(cat $file)" >> $tmpd/$files_from_file
	done
  echo $'\n'"$(realpath $BACKUP_USR_ROOT --relative-to=$HOME)" >> $tmpd/$files_from_file
	sort -o $tmpd/$files_from_file $tmpd/$files_from_file

  continue_prompt "Ready to copy files."
	# read -rsn1 -p "Ready to copy files. Press any key to continue..."$'\n'
	# Start sync to folder
	echo "Starting backup..."
	FILENAME=$(date +'%Y-%m-%d-%H%M%S')
  continue_prompt "Ready to copy files."
	rsync -ar --info=progress2 \
    --files-from="$tmpd/$files_from_file" \
    --exclude="$(realpath $tmpd --relative-to=$HOME)" \
    "$HOME" "$tmpd/$FILENAME/"

  continue_prompt "Ready to compress."
	# read -rsn1 -p "Ready to compress. Press any key to continue..."$'\n'
	echo "Creating $DIR_OUTPUT/$FILENAME.tar.gz"
	pushd $tmpd/$FILENAME/
	tar -czf "$DIR_OUTPUT/$FILENAME.tar.gz" .
	popd

	rm_dir_tmp
	echo "complete."
}