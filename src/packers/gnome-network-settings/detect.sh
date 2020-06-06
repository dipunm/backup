#!/bin/bash

[ "$(ls -1 /etc/NetworkManager/system-connections/*.nmconnection | wc -l)" -gt "0" ]