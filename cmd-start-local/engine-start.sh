#!/bin/bash

LOCAL_DIR="${PWD}"

echo "Local directory: $LOCAL_DIR"

BUILDER_DIR="$LOCAL_DIR/jdozer-fuzzer-builder"
ENGINE_DIR="$LOCAL_DIR/jdozer-fuzzer-engine"

if [ ! -d "$ENGINE_DIR" ]; then
    echo "Error: engine directory not found"
    exit 1
fi

cd "$BUILDER_DIR"
. ./env-set.sh

cd "$ENGINE_DIR"

npm install && npm run build && npm run start