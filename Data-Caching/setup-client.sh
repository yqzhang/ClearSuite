#!/bin/bash
## File: Data-Caching/setup-client.sh
## Usage: setup-client.sh [localhost|192.168.0.101]
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Caching"

if [ "$1" == "" ]
then
  echo "You need to specify the server to test, e.g. localhost, 192.168.0.1"
  exit 1
fi

# Check if libevent-dev is installed
echo "[$BENCHMARK] Check if libevent-dev is installed"
libevent_install=$(dpkg -s libevent-dev | grep installed)
if [ "$libevent_install" == "" ]
then
  echo "libevent-dev is needed, please install it before running this script"
  exit 1
fi

# Create directory for the benchmark
mkdir "$BENCHMARK-Client"
# Change directory
cd "$BENCHMARK-Client"

# Download Data Caching Benchmark
echo "[$BENCHMARK] Downloading Data Caching Benchmark ..."
wget http://parsa.epfl.ch/cloudsuite/software/memcached.tar.gz
# Uncompress the benchmark
echo "[$BENCHMARK] Uncompressing Data Caching Benchmark ..."
tar -xvf memcached.tar.gz

# Build load tester
echo "[$BENCHMARK] Build load tester ..."
cd memcached/memcached_client
sed -i "2 s|loader|loader -levent -pthread -lm|" Makefile
make
# Set the server list
echo "$1 11211" > servers.txt
