#!/bin/bash
## File: Graph-Analytics/start-synthetic.sh
## Usage: start-synthetic.sh
## Author: Matt Skach (skachm@umich.edu)
## Revised by: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Graph-Analytics"
NUMVERTICES=10000000

# Get hardware configuration
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
echo "[$BENCHMARK] The machine has $NUM_CORE logical cores in total."

echo "[$BENCHMARK] Running synthetic $NUMVERTICES vertice load:"
cd "$BENCHMARK"-Client/PowerGraph/release/toolkits/graph_analytics
./tunkrank --powerlaw=$NUMVERTICES --ncpus=$NUM_CORE --engine=asynchronous 
