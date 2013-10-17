#!/bin/bash
## File: Data-Serving/setup-client.sh
## Usage: setup-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to setup required packages on the client side
##        for Data-Serving which is a benchmark in CloudSuite.

BENCHMARK="Data-Serving"

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

# Download Data Serving Benchmark
echo "[$BENCHMARK] Downloading Data Serving Benchmark ..."
wget http://parsa.epfl.ch/cloudsuite/software/dataserving.tar.gz
# Uncompress the benchmark
echo "[$BENCHMARK] Uncompressing Data Serving Benchmark ..."
tar -xvf dataserving.tar.gz
# Remove useless files
echo "[$BENCHMARK] Remove useless files ..."
rm -rf apache-cassandra-0.7.3-bin.tar.gz

# Build ycsb.jar
echo "[$BENCHMARK] Build ycsb.jar ..."
cd YCSB
ant
ant dbcompile-cassandra-0.7
cd ..

# Configure the settings
# Load the server
echo "[$BENCHMARK] Load the server ..."
cd YCSB
NUM_CORE=`grep -c ^processor /proc/cpuinfo`
MEM_SIZE=`grep MemTotal /proc/meminfo | awk '{print $2}'`
echo "[$BENCHMARK] Generate $MEM_SIZE records for $MEM_SIZE KB memory"
# Modify settings_load.dat
sed -i "1 s|localhost|$2|" settings_load.dat
sed -i "2 s|1|$NUM_CORE|" settings_load.dat
sed -i "3 s|5000000|$MEM_SIZE|" settings_load.dat
