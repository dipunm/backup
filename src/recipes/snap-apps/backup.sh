#!/bin/bash

snap list --color=never --unicode=never | awk '$6!~/classic/ { print $1 }' > $DIR_STORE/snap.list
snap list --color=never --unicode=never | awk '$6~/classic/ { print $1 }' > $DIR_STORE/classic.list
