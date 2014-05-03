#!/bin/bash
#
# Run CloudSuite Data Analytics
#
# By Matt Skach
#

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk

# Clean up from previous run
cd analytics-release
cd mahout-distribution-0.6
rm -rf wikipediainput-output

echo "Starting Hadoop ..."
cd ../hadoop-0.20.2
bash bin/start-all.sh

echo "Running Data Analytics Benchmark ..."
cd ../mahout-distribution-0.6
bash bin/mahout testclassifier -m wikipediamodel -d wikipediainput --method mapreduce

echo "Exiting Hadoop ..."
cd ../hadoop-0.20.2
bash bin/stop-all.sh

