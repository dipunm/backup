
restore_recipes() {
	echo "Executing restorers..."
	for recipe in "${RESTORE[@]}"
	do
		if [ -f $dir_recipes_src/$recipe/restore.sh ]; then
			(
				export DIR_STORE="$dir_recipes_store/$recipe"
				$recipe_dir=$dir_recipes_src/$recipe
				$recipe_dir/restore.sh
			)
		else
			>&2 echo "Warning: Unable to find restorer for recipe: '$recipe'."
		fi
	done

	# Cleanup
	echo "Cleaning up temporary files..."
	rm -rf $tmpd

	echo "complete."
}

restore() {
	init_tmpd
	# We need a tar.gz file to start
	echo "Extracting backup..."
	pushd $HOME
	tar -xzvf $ARCHIVE
	popd

	restore_recipes
}

