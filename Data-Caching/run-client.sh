#!/bin/bash
## File: Data-Caching/run-client.sh
## Usage: run-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to run Memcached load tester on client side.

BENCHMARK="Data-Caching"

# Change directory
cd $1/$BENCHMARK/memcached/memcached_client

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

# Scale the dataset and warm up the cache box
echo "[$BENCHMARK] Scale the dataset to be around 10GB and warm cache up ..."
./loader -a ../twitter_dataset/twitter_dataset_unscaled \
  -o ../twitter_dataset/twitter_dataset_30x -s servers.txt \
  -w "$NUM_CORE" -S 30 -D 4096 -j -T 10
echo "[$BENCHMARK] Cached has already been warmed up ..."

# Sleep for a little bit
echo "[$BENCHMARK] Sleep for a little bit ..."
sleep 10

# Run the test
echo "[$BENCHMARK] Run the test with 80% GET forever
./loader -a ../twitter_dataset/twitter_dataset_30x \
  -s servers.txt -g 0.8 -T 1 -c 200 -w "$NUM_CORE"
