#!/bin/bash
## File: Data-Serving/start-client.sh
## Usage: start-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Serving"

# Start the test
echo "[$BENCHMARK] Start the test ..."
cd "$BENCHMARK"-Client/YCSB
./run.command
cd ..
