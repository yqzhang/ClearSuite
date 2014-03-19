#!/bin/bash
## File: Data-Caching/warmup-client.sh
## Usage: warmup-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Caching"

# Change directory
cd /"$BENCHMARK-Client"/memcached/memcached_client

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

# Scale the dataset and warm up the cache box
echo "[$BENCHMARK] Scale the dataset to be around 10GB and warm cache up ..."
./loader -a ../twitter_dataset/twitter_dataset_unscaled \
  -o ../twitter_dataset/twitter_dataset_30x -s servers.txt \
  -w "$NUM_CORE" -S 30 -D 4096 -j -T 10
echo "[$BENCHMARK] Cached has already been warmed up ..."
