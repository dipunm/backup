#!/bin/bash

ls -1 $NVM_DIR/versions/node > $DIR_STORE/node-versions.list
cp -r $NVM_DIR/alias $DIR_STORE