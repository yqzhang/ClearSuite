#!/bin/bash
## File: Media-Streaming/start-client.sh
## Usage: start-client.sh stresshigh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Media-Streaming"

# Change directory to the client
cd "$BENCHMARK-Client"

LOAD=$1

# Start the test
echo "[$BENCHMARK] Starting the test ..."
cd streaming-release/faban-streaming/streaming/
sh scripts/start-run.sh 2 $LOAD localhost 2
