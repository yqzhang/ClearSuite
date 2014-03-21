#!/bin/bash
## File: Media-Streaming/setup-client.sh
## Usage: setup-client.sh
## Author: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Media-Streaming"

echo "[$BENCHMARK] Check required applications ..."
REQUIRED_APPS=( "java" "sed" "ant" )
for app in "${REQUIRED_APPS[@]}"
do
  if [ ! type "$app" &> /dev/null ]
  then
    echo "$app is needed, please install it before running this script"
    exit 1
  fi
done

# Create directory for the benchmark
mkdir "$BENCHMARK-Server"
# Change directory
cd "$BENCHMARK-Server"


