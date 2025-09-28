#!/bin/bash

local_home=$(pwd)

jdfuzzer_version=0.9
jdozerfuzzer=jdozerfuzzer/jdozer-fuzzer-standalone:${jdfuzzer_version}

sudo docker stop jdfuzzer-std || true

sudo docker rm jdfuzzer-std || true

sudo docker image rm ${jdozerfuzzer} || true

#################################################################################################

seeder_home=../jdozer-fuzzer-seeder
vectors_home=../jdozer-fuzzer-vectors
engine_home=../jdozer-fuzzer-engine
processor_home=../jdozer-fuzzer-processor

cd $vectors_home
mvn dependency:resolve
quarkus build
cd $local_home

sudo docker build -t ${jdozerfuzzer} -f Dockerfile-standalone ../
sudo docker container create -p 8080:8080 -p 6379:6379 --name jdfuzzer-std ${jdozerfuzzer}
sudo docker start jdfuzzer-std

