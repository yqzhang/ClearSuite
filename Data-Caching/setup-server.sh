#!/bin/bash
## File: Data-Caching/setup-server.sh
## Usage: setup-server.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Data-Caching"

# Check if libevent-dev is installed
echo "[$BENCHMARK] Check if libevent-dev is installed"
libevent_install=$(dpkg -s libevent-dev | grep installed)
if [ "$libevent_install" == "" ]
then
  echo "libevent-dev is needed, please install it before running this script"
  exit 1
fi

# Create directory for the benchmark
mkdir "$BENCHMARK-Server"
# Change directory
cd "$BENCHMARK-Server"

# Download Memcached 1.4.15
echo "[$BENCHMARK] Downloading Memcached 1.4.15 ..."
wget http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz
# Uncompress Memcached 1.4.15
echo "[$BENCHMARK] Uncompress Memcached 1.4.15 ..."
tar -xvf memcached-1.4.15.tar.gz

# Configure and build Memcached
cd memcached-1.4.15
./configure
make 
