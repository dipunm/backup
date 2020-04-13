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
      assert_dir "$1" && export DIR_OUTPUT="$1"
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
  -a|--all)
    export RESTORE_MODE='all'
    export RESTORE_ALL='true'
  ;;
  -f|--files-only)
    export RESTORE_MODE='files'
  ;;
  -r|--recipes)
    export RESTORE_MODE='recipe'
    if [ $3 = '*' ]; then
      export RESTORE_ALL='true'
      # RECIPES will be loaded by config
      return;
    fi

    # [3...N]=recipeNames,
    RECIPES=( "${@:3}" )
  ;;
  *)
    echo_err "invalid option: '$2'."
    echo "Try '$0 --help' for more information."$'\n'
    exit 1
  ;;
  esac
}
