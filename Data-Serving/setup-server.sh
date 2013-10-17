#!/bin/bash
## File: Data-Serving/setup-server.sh
## Usage: setup-server.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to setup required packages on the server side
##        for Data-Serving which is a benchmark in CloudSuite.

BENCHMARK="Data-Serving"
RESULT_DIR="data_serving_result"

# Change directory
cd $1/$BENCHMARK

# Check all the required applications
echo "[$BENCHMARK] Check required applications ..."
REQUIRED_APPS=( "git" "ant" "javac" "sed" )
for app in "${REQUIRED_APPS[@]}"
do
  if [ ! type "$app" &> /dev/null ]
  then
    echo "$app is needed, please install it before running this script"
    exit 1
  fi
done

# Download Cassandra 0.7.3
echo "[$BENCHMARK] Downloading Cassandra 0.7.3 ..."
BINARY_DIR="0.7.3/apache-cassandra-0.7.3-bin.tar.gz"
wget http://archive.apache.org/dist/cassandra/$BINARY_DIR
# Umcompress Cassandra 0.7.3
echo "[$BENCHMARK] Uncompress Cassandra 0.7.3 ..."
tar -xvf apache-cassandra-0.7.3-bin.tar.gz

# Build Cassandra
echo "[$BENCHMARK] Change Cassandra configuration ..."
# Create result directories
PARENT_DIR=`pwd`
RESULT_PATH="$PARENT_DIR/$RESULT_DIR"
mkdir "$RESULT_PATH"
mkdir "$RESULT_PATH/data"
mkdir "$RESULT_PATH/commitlog"
mkdir "$RESULT_PATH/saved_caches"

# Change result directory configurations
cd apache-cassandra-0.7.3
sed -i \
  "72 s|/var/lib/cassandra/data|$RESULT_PATH/data|" \
  conf/cassandra.yaml
sed -i \
  "75 s|/var/lib/cassandra/commitlog|$RESULT_PATH/commitlog|" \
  conf/cassandra.yaml
sed -i \
  "78 s|/var/lib/cassandra/saved_caches|$RESULT_PATH/saved_caches|" \
  conf/cassandra.yaml
sed -i \
  "35 s|/var/log/cassandra/system.log|$RESULT_PATH/system.log|" \
  conf/log4j-server.properties
cd ..

# Create data schema
echo "[$BENCHMARK] Create data schema ..."
cd apache-cassandra-0.7.3
bin/cassandra -f &
sleep 10
bin/cassandra-cli --host localhost -f ../dataset-generation.txt
cd ..
