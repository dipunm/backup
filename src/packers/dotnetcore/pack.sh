#!/bin/bash

apt-mark showmanual | grep "dotnet-" >"$DIR_STORE/installed"