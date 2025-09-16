#!/bin/bash

local_home=$(pwd)

docker stop fuzzer-engine fuzzer-vectors fuzzer-seeder fuzzer-processor || true

docker rm fuzzer-engine fuzzer-vectors fuzzer-seeder fuzzer-processor || true

docker image rm fuzzer-engine:0.9 fuzzer-vectors:0.9 fuzzer-seeder:0.9 fuzzer-processor:0.9 || true

#################################################################################################

env_file=fuzzer.properties
fuzzer_network=fuzzer-network

. ./env-set.sh

mysql_version=0.9
redis_version=0.9

seeder_version=0.9
seeder_home=../jdozer-fuzzer-seeder
seeder_dockerfile=${seeder_home}/Dockerfile

vectors_version=0.9
vectors_home=../jdozer-fuzzer-vectors
vectors_dockerfile=${vectors_home}/src/main/docker/Dockerfile.jvm

engine_version=0.9
engine_home=../jdozer-fuzzer-engine
engine_dockerfile=${engine_home}/Dockerfile

processor_version=0.9
processor_home=../jdozer-fuzzer-processor
processor_dockerfile=${processor_home}/Dockerfile

backend_version=0.9
frontend_version=0.9

docker network create $fuzzer_network || true

########### Database ###########
# docker build -t fuzzer-mysql:$fuzzer_mysql_version .
# docker container create -e MYSQL_ROOT_PASSWORD=123456 -p 3306:3306 --name fuzzer-mysql fuzzer-mysql:$fuzzer_mysql_version
# docker network connect fuzzer-network fuzzer-mysql
# docker start fuzzer-mysql


########### Redis ###########
# docker build -t fuzzer-redis:$fuzzer_redis_version --file Dockerfile-Redis .
# docker container create -p 6379:6379 --name fuzzer-redis fuzzer-redis:$fuzzer_redis_version
# docker network connect fuzzer-network fuzzer-redis
# docker start fuzzer-redis

########### Prometheus ###########
# docker build -t fuzzer-prometheus:1.0 --file Dockerfile .
# docker container create -p 9090:9090 --name fuzzer-prometheus fuzzer-prometheus:1.0
# docker network connect fuzzer-network fuzzer-prometheus
# docker start fuzzer-prometheus

########### Grafana ###########
# docker build -t fuzzer-grafana:1.0 --file Dockerfile .
# docker container create -p 3000:3000 --name fuzzer-grafana fuzzer-grafana:1.0
# docker network connect fuzzer-network fuzzer-grafana
# docker start fuzzer-grafana


########### fuzzer-engine ###########
docker build -t fuzzer-engine:$engine_version -f $engine_dockerfile $engine_home
docker container create -p ${FUZZER_ENGINE_PORT}:8080 --name fuzzer-engine --env-file=$env_file fuzzer-engine:$engine_version
docker network connect $fuzzer_network fuzzer-engine
docker start fuzzer-engine

## export NODE_OPTIONS=--disable-warning=DEP0174

cd $vectors_home
# quarkus build --no-codegen --no-test --output target/uberjar/jdozer-fuzzer-vectors.jar
mvn dependency:resolve
quarkus build
cd $local_home

########### fuzzer-vectors ###########
docker build -t fuzzer-vectors:$vectors_version -f $vectors_dockerfile $vectors_home
docker container create -p ${FUZZER_VECTORS_PORT}:8080 --name fuzzer-vectors --env-file=$env_file fuzzer-vectors:$vectors_version
docker network connect $fuzzer_network fuzzer-vectors
docker start fuzzer-vectors


########### fuzzer-seeder ###########
docker build -t fuzzer-seeder:$seeder_version -f $seeder_dockerfile $seeder_home
docker container create -p ${FUZZER_SEEDER_PORT}:8080 --name fuzzer-seeder --env-file=$env_file fuzzer-seeder:$seeder_version
docker network connect $fuzzer_network fuzzer-seeder
docker start fuzzer-seeder

########### fuzzer-processor ###########
docker build -t fuzzer-processor:$processor_version -f $processor_dockerfile $processor_home
docker container create -p ${FUZZER_PROCESSOR_PORT}:8080 --name fuzzer-processor --env-file=$env_file fuzzer-processor:$processor_version
docker network connect $fuzzer_network fuzzer-processor
docker start fuzzer-processor

########### fuzzer-backend ###########
# docker build -t fuzzer-backend:0.9 .
# docker container create -p $FUZZER_BACKEND_PORT:8080 --name fuzzer-backend --env-file=../fuzzer.properties fuzzer-backend:0.9
# docker network connect fuzzer-network fuzzer-backend
# docker start fuzzer-backend


########### fuzzer-frontend ###########
# docker build -t fuzzer-frontend:0.9 .
# docker container create -p $FUZZER_FRONTEND_PORT:8080 --name fuzzer-frontend --env-file=../fuzzer.properties fuzzer-frontend:0.9
# docker network connect fuzzer-network fuzzer-frontend
# docker start fuzzer-frontend
