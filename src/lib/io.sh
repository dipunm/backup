continue_prompt() {
  # discard user input from buffer before accepting confirmation.
  read -rs -d '' -t 0.1
  # Optional custom message
  [ -n "$1" ] && echo -n "$1 "
	read -rsn1 -p "Press any key to continue..."$'\n'
}

echo_err() {
  echo $* >&2
}

join_by() { 
  local IFS="$1" 
  shift
  echo "$*" 
}

ask() {
  case "$1" in
    -y)
      read -r -p "$2 [Y/n]: " response
      case "$response" in
        [nN][oO]|[nN])
          return 1
        ;;
        *)
          return 0
        ;;
      esac  
    ;;
    *)
      read -r -p "${2:-1} [y/N]: " response
      case "$response" in
        [yY][eE][sS]|[yY])
          return 0
        ;;
        *)
          return 1
        ;;
      esac
    ;;
  esac
}