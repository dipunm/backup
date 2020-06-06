parse_command() {
  case $1 in
    -h|--help|'')
      export COMMAND='help'
    ;;
    -v|--version)
      export COMMAND='version'
    ;;
    backup|restore)
      export COMMAND=$1
    ;;
    *)
      echo_err "unknown command '$1'." && \
      echo "Try '$0 --help' for more information."$'\n' && \
      exit 1
    ;;
  esac
}

parse_backup_args() {
  case $1 in
    -o|--out)
      assert_dir "$2" && export DIR_OUTPUT="$2"
    ;;
    *)
      echo_err "invalid option '$1'." && \
      echo "Try '$0 --help' for more information."$'\n' && \
      exit 1
    ;;
  esac
}

parse_restore_args() {
  assert_file $1 "archive"
  export ARCHIVE=$1
  case $2 in
    -p|--parcels)
      export PARCELS=( "${@:3}" )
    ;;
  esac
}
