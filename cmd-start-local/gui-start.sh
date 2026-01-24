#!/bin/bash

LOCAL_DIR="${PWD}"

echo "Local directory: $LOCAL_DIR"

BUILDER_DIR="$LOCAL_DIR/jdozer-fuzzer-builder"
GUI_DIR="$LOCAL_DIR/jdozer-fuzzer-gui"

if [ ! -d "$GUI_DIR" ]; then
    echo "Error: gui directory not found"
    exit 1
fi

cd "$BUILDER_DIR"
. ./env-set.sh

cd "$GUI_DIR"

npm install && npm run build && npm run start