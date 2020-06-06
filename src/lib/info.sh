VERSION_INFO=$(cat "$BACKUP_USR_ROOT/src/version")
version() {
	echo "$VERSION_INFO"
}

help() {
	echo "\
Usage:
  $0 backup [-o <dir>]
  $0 restore <archive> [-p <parcels>...]
  $0 --help | -h
  $0 --version | -v

Commands:
  backup                Creates a backup to a specified directory.
  restore <archive>     Unpacks all parcels from the provided 
                        archive file.
  -v, --version         Show version.
  -h, --help            Display this screen.

Options:
  -o, --out <dir>       Specify the directory to write the backup to.
                        [ default: current working directory ]
  -p, --parcels <...>   Specify a subset of parcels to unpack.
"
}