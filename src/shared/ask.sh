#!/bin/bash

##############
# Prints a given message and allows the user to answer yes or no.
# Adding the -y flag sets the default value to Yes.
#
# USAGE:
# > ./ask.sh "Are you sure? (defaults to No)"
# Are you sure? (defaults to No) [y/N]: 
#
# > ./ask.sh -y "Are you sure? (defaults to Yes)"
# Are you sure? (defaults to Yes) [Y/n]: 
#
# > ./ask.sh -n "Are you sure? (defaults to No)"
# Are you sure? (defaults to No) [y/N]: 
##############

case "$1" in
  -y)
    read -r -p "$2 [Y/n]: " response
    case "$response" in
      [nN][oO]|[nN])
        exit 1
      ;;
      *)
        exit 0
      ;;
    esac  
  ;;
  *)
    read -r -p "${2:-$1} [y/N]: " response
    case "$response" in
      [yY][eE][sS]|[yY])
        exit 0
      ;;
      *)
        exit 1
      ;;
    esac
  ;;
esac