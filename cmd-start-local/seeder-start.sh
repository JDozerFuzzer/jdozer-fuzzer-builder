#!/bin/bash

LOCAL_DIR="${PWD}"

echo "Local directory: $LOCAL_DIR"

BUILDER_DIR="$LOCAL_DIR/jdozer-fuzzer-builder"
SEEDER_DIR="$LOCAL_DIR/jdozer-fuzzer-seeder"

if [ ! -d "$SEEDER_DIR" ]; then
    echo "Error: seeder directory not found"
    exit 1
fi

cd "$BUILDER_DIR"
. ./env-set.sh

cd "$SEEDER_DIR"

npm install && npm run build && npm run start