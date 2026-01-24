#!/bin/bash

LOCAL_DIR="${PWD}"


echo "Local directory: $LOCAL_DIR"

BUILDER_DIR="$LOCAL_DIR/jdozer-fuzzer-builder"
SOCKET_DIR="$LOCAL_DIR/jdozer-fuzzer-socket"

if [ ! -d "$SOCKET_DIR" ]; then
    echo "Error: socket directory not found"
    exit 1
fi

cd "$BUILDER_DIR"
. ./env-set.sh

cd "$SOCKET_DIR"

npm install && npm run build && npm run start