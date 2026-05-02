#!/bin/bash

LOCAL_DIR="${PWD}"

echo "Local directory: $LOCAL_DIR"

BUILDER_DIR="$LOCAL_DIR/jdozer-fuzzer-builder"
PROCESSOR_DIR="$LOCAL_DIR/jdozer-fuzzer-processor"

if [ ! -d "$PROCESSOR_DIR" ]; then
    echo "Error: processor directory not found"
    exit 1
fi

cd "$BUILDER_DIR"
. ./env-set.sh

cd "$PROCESSOR_DIR"

npm install && npm run build && npm run start