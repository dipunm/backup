VERSION_INFO=$(cat "$BACKUP_USR_ROOT/src/version")
version() {
	unset cleanup_message
	echo "$VERSION_INFO"
}

help() {
  unset cleanup_message
	echo "\
Usage:
  $0 backup [-o DIR]
  $0 restore ARCHIVE (-a|-f|-r RECIPE...)

Commands:
  backup                Creates a backup to a specified directory.
  restore ARCHIVE       Restores files and/or recipes from the 
                        provided archive file.

Options:
  -v --version          Show version.

  -h --help             Display this screen.

  -o, --out=DIR         Specify the directory to restore the backup to.
                        [ default: ~/ ]

  -a, --all             Performs a full restore in an interactive mode
                        to ensure a controlled restore experience.

  -f, --files-only      Restores the backed up files without attempting
                        to restore any recipes.

  -r, --recipes A B     Restores the named recipes from the archive.
                        Run all recipes configured in the backup by 
                        passing the value: \"all\"
"
}