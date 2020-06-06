#!/bin/bash

# For now, only Ubuntu is supported/tested, but contributions are welcome.
which docker >/dev/null && [[ "$(lsb_release -i)" =~ "Ubuntu" ]]