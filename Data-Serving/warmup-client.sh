#!/bin/bash
## File: Data-Serving/warmup-client.sh
## Usage: warmup-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Serving"

# Warmup the server by loading data to it
echo "[$BENCHMARK] Warmup the server by loading data to it ..."
cd "$BENCHMARK"-Client/YCSB
./run_load.command
sleep 10
