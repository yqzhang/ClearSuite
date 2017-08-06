#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends bc build-essential libssl-dev

mkdir build
cd build
../videoperf/configure && make && make install

mkdir output
