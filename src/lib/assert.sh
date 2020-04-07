assert_no_sudo() {
  [ ! -n "$SUDO_USER" ] && return
  echo_err "sudo detected."
  echo "You must run this program without elevated priviliges."
  exit 1
}

assert_file() {
  [ -f "$1" ] && return
  local type="${2:-'file'}"
  echo_err "$type not found: $1"
  exit 1
}

assert_dir() {
  [ -d "$1" ] && return
  echo_err "directory not found: $1"
  exit 1
}