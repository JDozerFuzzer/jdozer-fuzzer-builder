#!/bin/bash

LOCAL_DIR="${PWD}"

echo "Local directory: $LOCAL_DIR"

BUILDER_DIR="$LOCAL_DIR/jdozer-fuzzer-builder"
VECTORS_DIR="$LOCAL_DIR/jdozer-fuzzer-vectors"

if [ ! -d "$VECTORS_DIR" ]; then
    echo "Error: seeder directory not found"
    exit 1
fi

cd "$BUILDER_DIR"
. ./env-set.sh

cd "$VECTORS_DIR"

# Vectors es un proyecto en Quarkus
mvn dependency:resolve
mvn clean package
java -jar target/quarkus-app/quarkus-run.jar