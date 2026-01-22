#!/bin/bash

datetime_start=$(date +"%Y-%m-%d_%H-%M-%S")

set -e
redis-server /etc/redis/redis.conf --daemonize yes

cd $FUZZER_ENGINE_PATH && npm run start:prod &
cd $FUZZER_PROCESSOR_PATH && npm run start:prod &
java -jar $FUZZER_VECTOR_PATH/quarkus-run.jar &
cd $FUZZER_SEEDER_PATH
exec npm run start:prod