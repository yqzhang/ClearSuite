#!/usr/bin/env bash

SERVER_IP=$1

cd run
exec ./benchmark.sh ${SERVER_IP}
