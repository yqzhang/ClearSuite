#!/bin/bash
## File: Data-Caching/setup-client.sh
## Usage: setup-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Caching"

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
make

# Change the server configuration
echo "[$BENCHMARK] Please edit the server configuration memcached/memcached_client/servers.txt"
echo "             to the server IP you want to test or localhost if it is on the same machine."
