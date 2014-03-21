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
mkdir "$BENCHMARK-Client"
# Change directory
cd "$BENCHMARK-Client"

# Download Media Streaming benchmark
echo "[$BENCHMARK] Downloading Media Streaming benchmark  ..."
echo "[$BENCHMARK] This could take a long while D:"
wget http://parsa.epfl.ch/cloudsuite/software/streaming.tar.gz
# Umcompress the benchmark
tar -xvf streaming.tar.gz
# Change directory to Media-Streaming-Client/streaming-release/
cd streaming-release
# Uncompress faban
tar -xvf faban-kit-022311.tar.gz
# Move the benchmark to faban-streaming
mv faban faban-streaming
# Copy the streaming directory
cp -r streaming faban-streaming/
# Start faban master
cd faban-streaming
./master/bin/startup.sh

# Change configuration files
echo "[$BENCHMARK] Changing configuration files ..."
FABAN_DIR=`pwd`
cd streaming
sed -i "2 s|/home/username/faban-streaming/|$FABAN_DIR/|" \
  build.properties
sed -i "4 s|ant.home=|ant.home=/usr/bin/ant|" \
  build.properties
# Run new_depoly.sh
echo "[$BENCHMARK] Build faban ..."
sh scripts/new_deploy.sh

# Install cURL
echo "[$BENCHMARK] Installing cURL ..."
cd ../../../
wget http://curl.haxx.se/download/curl-7.35.0.tar.gz
tar -xvf curl-7.35.0.tar.gz
cd curl-7.35.0
CURL_DIR=`pwd`
mkdir curlinst
./configure --prefix="$CURL_DIR"/curlinst/ --enable-rtsp
make
make install

# Build RTSP client code
cd "$FABAN_DIR"
cd streaming
gcc -I "$CURL_DIR"/curlinst/include/ -L "$CURL_DIR"/curlinst/lib/ \
  -lcurl rtspclientfinal.c -o rtspclient.o -lcurl
