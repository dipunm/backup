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