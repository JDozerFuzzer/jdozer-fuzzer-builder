#!/usr/bin/env bash

export $(grep -v '^#' fuzzer-dev.properties | xargs)
## && env
