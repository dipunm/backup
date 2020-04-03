VERSION_INFO=$(cat "$BACKUP_USR_ROOT/src/version")
version() {
	echo "$VERSION_INFO"
}

help() {
	echo \
  "Usage:
  $0 backup [-o DIR]
  $0 restore ARCHIVE
  $0 restore -r RECIPE

Commands:
  backup                Creates a backup to a specified directory.
  restore               Restores your system using the provided backup 
                        file.

Options:
  -v --version          Show version.

  -h --help             Display this screen.

  -o, --out=DIR         Specify the directory to restore the backup to.
                        [ default: ~/ ]

  -r, --recipe=RECIPE   Specify a single recipe to restore.

Positional:
  ARCHIVE               The tar.gz file to restore. This file will be
                        restored to your \$HOME directory.
"
}