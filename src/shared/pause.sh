#!/bin/bash

##############
# Pauses execution, prints an optional message, 
# and prompts the user to press any key to continue.
#
# USAGE:
# > ./pause.sh
# Press any key to continue...
#
# > ./pause.sh "Everything is awesome!"
# Everything is awesome! Press any key to continue...
##############

  # discard user input from buffer before accepting confirmation.
  read -rs -d '' -t 0.1
  # Optional custom message
  [ -n "$1" ] && echo -n "$1 "
	read -rsn1 -p "Press any key to continue..."$'\n'