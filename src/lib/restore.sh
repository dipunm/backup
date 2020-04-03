export failed_recipes=()
recipe_restore() {
	local recipe=$1

	[ ! -f "$dir_recipes_src/$recipe/restore.sh" ] && \
		echo_err "$recipe: could not find recipe" && return

	tput sc
	continue_prompt "restoring: $recipe."
	
	(
		export DIR_STORE="$dir_recipes_store/$recipe"
		export DIR_TMP=$dir_tmp
		export DIR_RECIPE="$dir_recipes_src/$recipe"
		
		mkdir -p $DIR_STORE

		$DIR_RECIPE/restore.sh
	)
	local subsh_code="$?"

	[ "$subsh_code" == "0" ] && tput rc && tput ed && echo "$recipe: completed successfully." && return
	
	failed_recipes+=( $recipe )
	echo_err "$recipe: Exited with code $subsh_code."
}

full_restore() {
	assert_file "$ARCHIVE" "archive"
	
	echo "# Restoring files from archive"
	continue_prompt "This command will overwrite files in your \$HOME directory."
	
	pushd $HOME
	tar -xzf $ARCHIVE
	popd

	echo $'\n'"# Restoring recipes"
	for recipe in "${RECIPES[@]}"
	do
		recipe_restore $recipe
	done

	if [ "${#failed_recipes[@]}" -gt "0" ]; then
		echo_err "the following recipes failed: $(join_by ', ' ${failed_recipes[@]})"
	fi
}

restore() {
	[ -n "$RECIPE" ] && recipe_restore $RECIPE && exit

	full_restore && exit
}
