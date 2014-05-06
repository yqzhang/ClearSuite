#!/bin/bash
## File: Data-Caching/warmup-server.sh
## Usage: warmup-server.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Caching"

# Change directory
cd "$BENCHMARK-Server"/memcached-1.4.19

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

# Start the Memcached server
echo "[$BENCHMARK] Start the server with 4GB memory and $NUM_CORE threads."
./memcached -t "$NUM_CORE" -m 4096 -n 550 &
