#!/bin/bash
## File: Graph-Analytics/start-large-twitter.sh
## Usage: start-large-twitter.sh
## Author: Matt Skach (skachm@umich.edu)
## Revised by: Yunqi Zhang (yunqi@umich.edu)

BENCHMARK="Graph-Analytics"

# Create directory for the benchmark
mkdir "$BENCHMARK"-Client
# Change directory
cd "$BENCHMARK"-Client

# Install PowerGraph
echo "[$BENCHMARK] Downloading PowerGraph ..."
git clone https://github.com/dato-code/PowerGraph.git
wget http://parsa.epfl.ch/cloudsuite/software/tunkrank.cpp
mv tunkrank.cpp PowerGraph/toolkits/graph_analytics/tunkrank.cpp
echo "add_graphlab_executable(tunkrank tunkrank.cpp)" >> PowerGraph/toolkits/graph_analytics/CMakeLists.txt

echo "[$BENCHMARK] Configuring PowerGraph ..."
cd PowerGraph
./configure

echo "[$BENCHMARK] Building TunkRank ..."
cd release/toolkits/graph_analytics 
make tunkrank
cd ../../../..

#exit # Stop here for synthetic setup only

# Set up different dataset
# Small twitter dataset
echo "[$BENCHMARK] Configuring small twitter dataset ..."
echo "[$BENCHMARK] #########################################"
echo "[$BENCHMARK] Sometimes this link does not work well :("
echo "[$BENCHMARK] #########################################"
wget http://socialcomputing.asu.edu/uploads/1296759055/Twitter-dataset.zip
echo "[$BENCHMARK] Uncompressing small twitter dataset ..."
unzip Twitter-dataset.zip
cd Twitter-dataset/data
cat edges.csv | awk -F"," '{print $1, $2}' > twitter_small_data_graplab.in
rm -f edges.csv
rm -f nodes.csv
cd ../..

# Large Twitter dataset
echo "[$BENCHMARK] Configuring large twitter dataset ..."
wget an.kaist.ac.kr/~haewoon/release/twitter_social_graph/twitter_rv.tar.gz
# From: http://an.kaist.ac.kr/traces/WWW2010.html
# Official page didn't work. I do not know how permanent this mirror is...
echo "[$BENCHMARK] Uncompressing large twitter dataset ..."
tar zxvf twitter_rv.tar.gz 
mkdir twitter_rv
mv twitter_rv.net twitter_rv/.
cd twitter_rv
cat twitter_rv.net | awk '{print $2, $1}' > twitter_data_graplab.in 
rm -f twitter_rv.net
cd ..

