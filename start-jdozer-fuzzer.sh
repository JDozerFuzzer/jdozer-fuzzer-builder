#!/bin/bash

datetime_start=$(date +"%Y-%m-%d_%H-%M-%S")

set -e
redis-server /etc/redis/redis.conf --daemonize yes

cd $FUZZER_ENGINE_PATH && npm run start:prod >> $FUZZER_LOG_DIR/engine_${datetime_start}.log 2>&1 &
cd $FUZZER_PROCESSOR_PATH && npm run start:prod >> $FUZZER_LOG_DIR/processor_${datetime_start}.log 2>&1 &
java -jar $FUZZER_VECTOR_PATH/quarkus-run.jar >> $FUZZER_LOG_DIR/vectors_${datetime_start}.log 2>&1 &
cd $FUZZER_SEEDER_PATH
exec npm run start:prod >> $FUZZER_LOG_DIR/seeder_${datetime_start}.log 2>&1