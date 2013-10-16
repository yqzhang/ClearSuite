#!/bin/bash
## File: data-serving.sh
## Usage: data-serving.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to install all the packages needed to run
##        data-serving, which is a benchmark in CloudSuite.

BENCHMARK="Data-Serving";
RESULT_DIR="data_serving_result";

# Check all the required applications
echo "[$BENCHMARK] Check required applications ...";
REQUIRED_APPS=( "git" "ant" "javac" "sed" );
for app in "${REQUIRED_APPS[@]}"
do
  if ! type "$app" &> /dev/null; then
    echo "$app is needed, please install it before running this script";
    exit 1;
  fi
done

# Download Data Serving Benchmark
echo "[$BENCHMARK] Downloading Data Serving Benchmark ...";
wget http://parsa.epfl.ch/cloudsuite/software/dataserving.tar.gz
# Uncompress the benchmark
echo "[$BENCHMARK] Uncompressing Data Serving Benchmark ...";
tar -xvf dataserving.tar.gz
# Remove useless files
echo "[$BENCHMARK] Remove useless files ...";
rm -rf apache-cassandra-0.7.3-bin.tar.gz

# Download Cassandra 0.7.3
echo "[$BENCHMARK] Downloading Cassandra 0.7.3 ...";
BINARY_DIR="0.7.3/apache-cassandra-0.7.3-bin.tar.gz";
wget http://archive.apache.org/dist/cassandra/$BINARY_DIR;
# Umcompress Cassandra 0.7.3
echo "[$BENCHMARK] Uncompress Cassandra 0.7.3 ...";
tar -xvf apache-cassandra-0.7.3-bin.tar.gz;
# Copy *.jar files from Cassandra to YCSB
cp apache-cassandra-0.7.3/lib/*.jar YCSB/db/cassandra-0.7/lib/

# Build ycsb.jar
echo "[$BENCHMARK] Build ycsb.jar ...";
cd YCSB
ant
ant dbcompile-cassandra-0.7
cd ..

# Build Cassandra
echo "[$BENCHMARK] Change Cassandra configuration ...";
# Create result directories
PARENT_DIR=`pwd`
RESULT_PATH="$PARENT_DIR/$RESULT_DIR";
mkdir "$RESULT_PATH";
mkdir "$RESULT_PATH/data";
mkdir "$RESULT_PATH/commitlog";
mkdir "$RESULT_PATH/saved_caches";
cd apache-cassandra-0.7.3

# Change result directory configurations
sed -i \
  "72 s|/var/lib/cassandra/data|$RESULT_PATH/data|" \
  conf/cassandra.yaml;
sed -i \
  "75 s|/var/lib/cassandra/commitlog|$RESULT_PATH/commitlog|" \
  conf/cassandra.yaml;
sed -i \
  "78 s|/var/lib/cassandra/saved_caches|$RESULT_PATH/saved_caches|" \
  conf/cassandra.yaml;
sed -i \
  "35 s|/var/log/cassandra/system.log|$RESULT_PATH/system.log|" \
  conf/log4j-server.properties;
cd ..

# Generate dataset
echo "[$BENCHMARK] Generate testing dataset ...";
cd apache-cassandra-0.7.3
bin/cassandra -f &
sleep 10
bin/cassandra-cli --host localhost -f ../dataset-generation.txt
cd ..

# Load the server
echo "[$BENCHMARK] Load the server ...";
cd YCSB
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
MEM_SIZE=`grep MemTotal /proc/meminfo | awk '{print $2}'`
echo "[$BENCHMARK] Generate $MEM_SIZE records for $MEM_SIZE KB memory";
# Modify settings_load.dat
sed -i "2 s|1|$NUM_CORE|" settings_load.dat;
sed -i "3 s|5000000|$MEM_SIZE|" settings_load.dat;
./run_load.command
sleep 10

# Run the benchmark
echo "[$BENCHMARK] Run the benchmark ...";
./run.command
cd ..
