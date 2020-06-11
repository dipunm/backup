import() { 
	for path in "$@"
	do
		. "$BACKUP_USR_ROOT/src/${path}.sh"
	done
}
