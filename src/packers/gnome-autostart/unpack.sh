#!/bin/bash

rsync -rab --backup-dir=~/.local/backup "$DIR_STORE/.config/autostart" ~/.config