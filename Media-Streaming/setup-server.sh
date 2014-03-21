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

# Download the Darwin Streaming Server
echo "[$BENCHMARK] Downloading Darwin Streaming Server ..."
wget http://dss.macosforge.org/downloads/DarwinStreamingSrvr6.0.3-Source.tar
echo "[$BENCHMARK] Uncompressing Darwin Streaming Server ..."
tar -xvf DarwinStreamingSrvr6.0.3-Source.tar
echo "[$BENCHMARK] Downloading patches for Darwing Streaming Server ..."
wget http://parsa.epfl.ch/cloudsuite/software/darwin/dss-6.0.3.patch
wget http://parsa.epfl.ch/cloudsuite/software/darwin/dss-hh-20080728-1.patch
echo "[$BENCHMARK] Apply the patches ..."
cd DarwinStreamingSrvr6.0.3-Source/
patch -p1 < ../dss-6.0.3.patch 
patch -p1 < ../dss-hh-20080728-1.patch

# Download the install script
echo "[$BENCHMARK] Downloading the install script ..."
rm Install
wget http://parsa.epfl.ch/cloudsuite/software/darwin/Install
chmod +x Install

# Create new user and group for qtss
echo "[$BENCHMARK] Create new user and group for qtss, permission required ..."
sudo addgroup qtss
sudo adduser --system --no-create-home --ingroup qtss qtss

# Install the server
echo "[$BENCHMARK] Installing the server, permission required ..."
sed -i "9 s|-lQTFileLib|-lQTFileLib -ldl|" \
  Makefile.POSIX
sed -i "9 s|libCommonUtilitiesLib.a|libCommonUtilitiesLib.a -lpthread|" \
  QTFileTools/QTFileInfo.tproj/Makefile.POSIX
sed -i "9 s|libQTFileExternalLib.a|libQTFileExternalLib.a -lpthread|" \
  QTFileTools/QTFileTest.tproj/Makefile.POSIX
sed -i "9 s|libQTFileExternalLib.a|libQTFileExternalLib.a -lpthread|" \
  QTFileTools/QTSampleLister.tproj/Makefile.POSIX
sed -i "9 s|libQTFileExternalLib.a|libQTFileExternalLib.a -lpthread|" \
  QTFileTools/QTTrackInfo.tproj/Makefile.POSIX
./Buildit
sudo ./Install

# Change configuration
MOVIE_DIR=/usr/local/movies/
echo "[$BENCHMARK] Changing configurations, permission required ..."
sudo sed -i "120 s|/Library/QuickTimeStreaming/Movies|$MOVIE_DIR|" \
  /etc/streaming/streamingserver.xml
sudo sed -i "125 s|102400|-1|" \
  /etc/streaming/streamingserver.xml
sudo sed -i "128 s|1000|-1|" \
  /etc/streaming/streamingserver.xml
sudo sed -i "133 s|120|700|" \
  /etc/streaming/streamingserver.xml
sudo sed -i "135 s|180|700|" \
  /etc/streaming/streamingserver.xml
sudo sed -i "265 s|0|2|" \
  /etc/streaming/streamingserver.xml
sudo sed -i "268 s|2.0|1.2|" \
  /etc/streaming/streamingserver.xml
