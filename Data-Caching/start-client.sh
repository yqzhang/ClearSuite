#!/bin/bash
## File: Data-Caching/start-client.sh
## Usage: start-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Caching"

# Change directory
cd /"$BENCHMARK-Client"/memcached/memcached_client

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

# Run the test
echo "[$BENCHMARK] Run the test with 80% GET forever and $NUM_CORE threads."
./loader -a ../twitter_dataset/twitter_dataset_30x \
  -s servers.txt -g 0.8 -T 1 -c 200 -w "$NUM_CORE"
