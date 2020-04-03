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
      local o=$(cd "$2" 2>/dev/null && pwd)
      assert_dir "$o" && export DIR_OUTPUT=$o
    ;;
    *)
      echo_err "invalid option '$1'." && \
      echo "Try '$0 --help' for more information."$'\n' && \
      exit 1
    ;;
  esac
}

parse_restore_args() {
  case $1 in
    -r|--recipe)
      export RECIPE=$2
    ;;
    *)
      local f="$(cd $(dirname $1) 2>/dev/null && pwd)/$(basename $1)"
      assert_file $f
      export ARCHIVE=$f
    ;;
  esac
}