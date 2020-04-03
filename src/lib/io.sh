import() { 
	for path in "$@"
	do
		. "$BACKUP_USR_ROOT/src/${path}.sh"
	done
}

mk_dir_tmp() {
  local name="backup_tmp.$(date +'%s')"
  dir_tmp=$BACKUP_USR_ROOT/$name
	
  rm -rf $dir_tmp
	mkdir $dir_tmp
}

rm_dir_tmp() {
	if [ -d "$dir_tmp" ]; then
		echo "Cleaning up temporary files."
		rm -rf $dir_tmp
	fi
}

load_config() {
  assert_file "$dir_config/$1" "config"
  . "$dir_config/$1"
}