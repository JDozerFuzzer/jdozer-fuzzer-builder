#!/bin/bash
set -e

redis-server /etc/redis/redis.conf --daemonize yes
java -jar /app/quarkus/quarkus-run.jar &
cd /app/nestjs
exec node main.js


#docker build -t jfs:0.1 -f Dockerfile-standalone ../

#docker container create -p 8080:8080 --name std --env-file=fuzzer.properties jfs:0.1

#docker run -it --rm jfs:0.1 /bin/bash


RUN set -e && \
    cd /app/nestjs/jdozer-fuzzer-seeder && \
    npm install && \
    cd /app/nestjs/jdozer-fuzzer-engine && \
    npm install && \
    cd /app/nestjs/jdozer-fuzzer-processor && \
    npm install

RUN set -e && \
    redis-server /etc/redis/redis.conf --daemonize yes && \
    java -jar /app/quarkus/quarkus-run.jar & \
    cd /app/nestjs && \ 
    exec node jdozer-fuzzer-seeder/main.js & \
    exec node jdozer-fuzzer-engine/main.js & \
    exec node jdozer-fuzzer-processor/main.js & \
    pkill -f redis-server && \
    pkill -f quarkus-run.jar && \
    pkill -f main.js