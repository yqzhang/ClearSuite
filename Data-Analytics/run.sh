#!/bin/bash
#
# Run CloudSuite Data Analytics
#
# By Matt Skach
#

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk

# Check java path
if [ ! -e $JAVA_HOME ] ; then
  echo "JAVA_HOME not found, please update JAVA_HOME in the run script.";
  exit 1;
fi


echo "[Data-Analytics] Starting Hadoop ..."
cd analytics-release/hadoop-0.20.2
bash bin/start-all.sh

echo "[Data-Analytics] Running Data Analytics Benchmark ..."
cd ../mahout-distribution-0.6
bash bin/mahout testclassifier -m wikipediamodel -d wikipediainput --method mapreduce

echo "[Data-Analytics] Exiting Hadoop ..."
cd ../hadoop-0.20.2
bash bin/stop-all.sh

echo "[Data-Analytics] Recommend running 'killall java' before re-running the benchmark."
