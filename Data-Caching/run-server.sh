#!/bin/bash
## File: Data-Caching/run-server.sh
## Usage: run-server.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to run Memcached load tester on server side.

BENCHMARK="Data-Caching"

# Change directory
cd $1/$BENCHMARK/memcached-1.4.15

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

# Start the Memcached server
echo "[$BENCHMARK] Start the Memcached server with 4GB memory
./memcached -t "$NUM_CORE" -D 4096 -n 550
