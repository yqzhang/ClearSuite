#!/bin/bash
## File: Graph-Analytics/start-small-twitter.sh
## Usage: start-small-twitter.sh
## Author: Matt Skach (skachm@umich.edu)
## Revised by: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Graph-Analytics"

echo "Running $BENCHMARK with small twitter load:"
cd $TUNKRANKPATH

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

echo "[$BENCHMARK] Running with small twitter load:"
cd "$BENCHMARK"-Client/graph-release/release/toolkits/graph_analytics/
./tunkrank --graph=../../../Twitter-dataset/data/twitter_small_data_graplab.in \
  --format=tsv --ncpus=$NUMCORES --engine=asynchronous 
