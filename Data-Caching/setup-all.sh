#!/bin/bash
## File: Data-Caching/setup-all.sh
## Usage: setup-all.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to install all the packages needed to run
##        data-caching, which is a benchmark in CloudSuite.

BENCHMARK="Data-Caching"
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
echo "[$BENCHMARK] Set up $server_ip at repository $server_dir as server"
echo "[$BENCHMARK] and $client_ip at repository $client_dir as client."
echo "[$BENCHMARK] Is this correct (y/n)?"
read correct_host
if [ "$correct_host" == "n" ] || [ "$correct_host" == "N" ]
then
  echo "[$BENCHMARK] Please modify the hosts in $HOST_FILE"
  exit 1
fi

# Ship the scripts to server and client
echo "[$BENCHMARK] Ship scripts to $server_ip at $server_dir ..."
ssh $server_ip mkdir "$server_dir/Data-Caching"
scp setup-server.sh "$server_ip":"$server_dir/Data-Caching/"
ssh $server_ip \
  "$server_dir/Data-Caching/setup-server.sh $server_dir"

echo "[$BENCHMARK] Ship scripts to $client_ip at $client_dir ..."
ssh $client_ip mkdir "$client_dir/Data-Caching"
scp setup-client.sh "$client_ip":"$client_dir/Data-Caching/" "$server_ip"
ssh $client_ip \
  "$client_dir/Data-Caching/setup-client.sh $client_dir $server_ip"
