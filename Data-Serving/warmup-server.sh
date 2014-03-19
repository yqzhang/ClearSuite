#!/bin/bash
## File: Data-Serving/warmup-server.sh
## Usage: warmup-server.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Serving"

# Generate dataset
echo "[$BENCHMARK] Generate testing dataset ...";
cd "$BENCHMARK"-Server/apache-cassandra-0.7.3
bin/cassandra -f &
sleep 10
bin/cassandra-cli --host localhost -f ../dataset-generation.txt
cd ..
