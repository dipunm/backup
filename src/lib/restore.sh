export failed_recipes=()
restore_recipe_single() {
	local recipe=$1

	[ ! -f "$dir_recipes_src/$recipe/restore.sh" ] && \
		echo_err "$recipe: could not find recipe" && return

	tput sc
	continue_prompt "restoring: $recipe."
		
	(
		export DIR_STORE="$dir_recipes_store/$recipe"
		export DIR_TMP="$dir_tmp"
		export DIR_RECIPE="$dir_recipes_src/$recipe"
		
		mkdir -p "$DIR_STORE"

		"$DIR_RECIPE"/restore.sh
	)
	local subsh_code="$?"

	[ "$subsh_code" == "0" ] && tput rc && tput ed && echo "$recipe: completed successfully." && return
	
	failed_recipes+=( "$recipe" )
	echo_err "$recipe: Exited with code $subsh_code."
}

extract_files() {
	echo "# Restoring files from archive"
	continue_prompt "This command will overwrite files in your \$HOME directory."
	
	tar -xzf "$ARCHIVE" -C "$HOME" . && extract_store
}

extract_store() {
	echo "# Extracting recipe store"
	tar -xzf "$ARCHIVE" -C "$(dirname "$dir_recipes_store")" "$(basename "$dir_recipes_store")"
}

restore_recipes() {
	# reload config file to refresh list of recipes to execute
	[ RESTORE_ALL = 'true' ] && load_config main.conf

	export skipped_recipes=()
	echo $'\n'"# Restoring recipes"
	for recipe in "${RECIPES[@]}"
	do
		if [ "$FLOW" != "controlled" ] || ask -y "run recipe: $recipe?"; then
			restore_recipe_single "$recipe"
		else
			echo "skipping."
			skipped_recipes+=( "$recipe" )
		fi
	done

	if [ "${#failed_recipes[@]}" -gt "0" ]; then
		echo_err "the following recipes failed: $(join_by ', ' ${failed_recipes[@]})"
	fi

	if [ "${#skipped_recipes[@]}" -gt "0" ]; then
		echo_err "the following recipes were skipped: $(join_by ', ' ${skipped_recipes[@]})"
	fi
}

restore() {
	FLOW='auto'
	case "$RESTORE_MODE" in
	all)
		FLOW='controlled'
		extract_files
		restore_recipes
	;;
	files)
		extract_files
	;;
	recipe)
		extract_store
		restore_recipes
	;;
	esac
}
