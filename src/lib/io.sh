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