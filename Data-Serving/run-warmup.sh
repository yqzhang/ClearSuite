#!/bin/bash
## File: Data-Serving/run-warmup.sh
## Usage: run-warmup.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to warm up the Cassandra database.

BENCHMARK="Data-Serving"
HOST_FILE="hosts.txt"

# Read host list
echo "[$BENCHMARK] Read host list ..."
server_ip=""
client_ip=""
server_dir=""
client_dir=""
while read line
do
  line_array=($line)
  if [ "${line_array[0]}" == "server" ]
  then
    server_ip=${line_array[1]}
    server_dir=${line_array[2]}
  else
    client_ip=${line_array[1]}
    client_dir=${line_array[2]}
  fi
done < "$HOST_FILE"

# Check if we have both server and client in HOST_FILE
if [ "$server_ip" == "" ]
then
  echo "[$BENCHMARK] Error: A server is needed!"
  exit 1
fi
if [ "$client_ip" == "" ]
then
  echo "[$BENCHMARK] Error: A client is needed!"
  exit 1
fi

# Double-check the hosts with user
echo "[$BENCHMARK] Warm up server $server_ip at repository $server_dir"
echo "[$BENCHMARK] and client $client_ip at repository $client_dir."
echo "[$BENCHMARK] Is this correct (y/n)?"
read correct_host
if [ "$correct_host" == "n" ] || [ "$correct_host" == "N" ]
then
  echo "[$BENCHMARK] Please modify the hosts in $HOST_FILE"
  exit 1
fi

# Start warmup phase
ssh $client_ip "$client_dir/Data-Serving/YCSB/run_load.command"
