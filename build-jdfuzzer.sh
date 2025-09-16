#!/bin/bash

local_home=$(pwd)

jdfuzzer_version=0.9

docker stop jdfuzzer-std || true

docker rm jdfuzzer-std || true

docker image rm jdozer-fuzzer-standalone:${jdfuzzer_version} || true

#################################################################################################

seeder_home=../jdozer-fuzzer-seeder
vectors_home=../jdozer-fuzzer-vectors
engine_home=../jdozer-fuzzer-engine
processor_home=../jdozer-fuzzer-processor

#cd $vectors_home
#mvn dependency:resolve
#pwd
#quarkus build --no-codegen --no-test 
# --output target/uberjar/jdozer-fuzzer-vectors.jar
# quarkus build --no-codegen --no-test --output target/uberjar/jdozer-fuzzer-vectors.jar
#cd $local_home

docker build -t jdozer-fuzzer-standalone:${jdfuzzer_version} -f Dockerfile-standalone ../
docker container create -p 8080:8080 -p 6379:6379 --name jdfuzzer-std jdozer-fuzzer-standalone:${jdfuzzer_version}
docker start jdfuzzer-std

