#!/bin/bash
## File: Data-Caching/setup-client.sh
## Usage: setup-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to setup required packages on the client side
##        for Data-Caching which is a benchmark in CloudSuite.

BENCHMARK="Data-Caching"

# Change directory
cd $1/$BENCHMARK

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
echo "[$BENCHMARK] Change server configuration to server $1 ..."
echo "$1 11211" > servers.txt
