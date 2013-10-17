#!/bin/bash
## File: Data-Caching/run-test.sh
## Usage: run-test.sh
## Author: Yunqi Zhang (yunqi@umich.edu)
## Notes: This script is used to run Memcache test.

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
echo "[$BENCHMARK] Test server $server_ip at repository $server_dir"
echo "[$BENCHMARK] and client $client_ip at repository $client_dir."
echo "[$BENCHMARK] Is this correct (y/n)?"
read correct_host
if [ "$correct_host" == "n" ] || [ "$correct_host" == "N" ]
then
  echo "[$BENCHMARK] Please modify the hosts in $HOST_FILE"
  exit 1
fi

# Ship the scripts to server and client
echo "[$BENCHMARK] Ship the scripts to server and client ..."
scp run-server.sh "$server_ip":"$server_dir/$BENCHMARK/"
scp run-client.sh "$client_ip":"$client_dir/$BENCHMARK/"

# Start test
echo "[$BENCHMARK] Start the test ..."
ssh "$server_ip" "$server_dir/$BENCHMARK/run-server.sh" &
sleep 5
echo "[$BENCHMARK] Server $server_ip has already been started ..."
ssh "$client_ip" "$client_dir/$BENCHMARK/run-client.sh"
