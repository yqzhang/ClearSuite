#!/bin/bash
## File: Graph-Analytics/start-large-twitter.sh
## Usage: start-large-twitter.sh
## Author: Matt Skach (skachm@umich.edu)
## Revised by: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Graph-Analytics"
NUMVERTICES=10000000

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

echo "[$BENCHMARK] Running with large twitter load:"
cd "$BENCHMARK"-Client/PowerGraph/release/toolkits/graph_analytics
./tunkrank --graph=../../../../twitter_rv/twitter_data_graplab.in \
  --format=tsv --ncpus=$NUM_CORE --engine=asynchronous 
