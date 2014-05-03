#!/bin/bash
#
# Set up CloudSuite Data Analytics
#
# By Matt Skach
#

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk

HOMEPATH=`pwd`
FORMATTEDHADOOPTMPPATH=$(echo "$HOMEPATH/analytics-release/hadoop-0.20.2/tmp" | sed 's/\//\\\//g')
FORMATTEDHADOOPNAMEPATH=$(echo "$HOMEPATH/analytics-release/hadoop-0.20.2/namenode" | sed 's/\//\\\//g')
FORMATTEDHADOOPDATAPATH=$(echo "$HOMEPATH/analytics-release/hadoop-0.20.2/data" | sed 's/\//\\\//g')
FORMATTEDJAVAPATH=$(echo "$JAVA_HOME" | sed 's/\//\\\//g')

# Configure and install.
echo "Installing $BENCHMARK:"
echo "Downloading $BENCHMARK packages ..."
wget http://parsa.epfl.ch/cloudsuite/software/analytics.tar.gz

echo "Extracting $BENCHMARK package ..."
tar -zxvf analytics.tar.gz
rm -rf analytics.tar.gz

#echo "Setting up package..."
#cd $SSHKEYPATH
#echo "n\n" | ssh-keygen -t rsa -N "" -f "$SSHKEYNAME"
#cat $SSHKEYNAME.pub >> authorized_keys
#echo "NOTE: authorized_keys in $SSHKEYPATH must be copied to each node."

echo "Setting up Hadoop..."
cd analytics-release
tar -zxvf hadoop.tar.gz


cd hadoop-0.20.2
mkdir tmp
mkdir namenode
mkdir data

cd conf
cp hadoop-env.sh hadoop-env.sh.bak
sed -i "s/absolute_path_to_java_home/$FORMATTEDJAVAPATH/g" hadoop-env.sh
cp core-site.xml core-site.xml.bak
cp mapred-site.xml mapread-site.xml.bak
cp hdfs-site.xml hdfs-site.xml.bak
cp ../../../xml/core-site.xml .
cp ../../../xml/mapred-site.xml .
cp ../../../xml/hdfs-site.xml .
sed -i "s/absolute_path_to_tmp_dir/$FORMATTEDHADOOPTMPPATH/g" hdfs-site.xml
sed -i "s/absolute_path_to_namenode_dir/$FORMATTEDHADOOPNAMEPATH/g" hdfs-site.xml
sed -i "s/absolute_path_to_data_dir/$FORMATTEDHADOOPDATAPATH/g" hdfs-site.xml


cd ..
echo "Y\n" | bash bin/hadoop namenode -format


echo "Starting Hadoop ..."
bash bin/start-all.sh


echo "Setting up Mahout ..."
cd ..
tar -zxvf mahout.tar.gz

cd mahout-distribution-0.6
mvn install -DskipTests


echo "Downloading Wikipedia data ..."
mkdir examples/temp
cd examples/temp
wget download.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2

echo "Extracting Wikipedia data package (slow!) ..."
bunzip2 enwiki-latest-pages-articles.xml.bz2
cd ../..
echo "Chunking Wikipedia data (slow!)..."
bash bin/mahout wikipediaXMLSplitter -d examples/temp/enwiki-latest-pages-articles.xml -o wikipedia/chunks -c 64
echo "Verifying Wikipedia data chunks ..."
bash ../hadoop-0.20.2/bin/hadoop dfs -ls wikipedia/chunks
cd examples/temp
rm enwiki-latest-pages-articles.xml


echo "Downloading Wikipedia training data ..."
wget http://parsa.epfl.ch/cloudsuite/software/enwiki-20100904-pages-articles1.xml.bz2
echo "Extracting Wikipedia training data package (slow!) ..."
bunzip2 enwiki-20100904-pages-articles1.xml.bz2
cd ../..
echo "Chunking Wikipedia training data (slow!)..."
bash bin/mahout wikipediaXMLSplitter -d examples/temp/enwiki-20100904-pages-articles1.xml -o wikipedia-training/chunks -c 64

echo "Verifying Wikipedia training data chunks ..."
bash ../hadoop-0.20.2/bin/hadoop dfs -ls wikipedia-training/chunks
cd examples/temp
rm enwiki-20100904-pages-articles1.xml
cd ../../../..


echo "Copying Wikipedia categories ..."

cp analytics-release/categories.txt analytics-release/mahout-distribution-0.6/examples/temp/categories.txt

cd analytics-release/mahout-distribution-0.6

echo "Creating Wikipedia training data categories ..."
bash bin/mahout wikipediaDataSetCreator -i wikipedia-training/chunks -o traininginput -c examples/temp/categories.txt
echo "Verifying Wikipedia training data categories ..."
bash ../hadoop-0.20.2/bin/hadoop fs -ls traininginput


echo "Creating Wikipedia data categories ..."
bash bin/mahout wikipediaDataSetCreator -i wikipedia/chunks -o wikipediainput -c examples/temp/categories.txt
echo "Verifying Wikipedia data categories ..."
bash ../hadoop-0.20.2/bin/hadoop fs -ls wikipediainput


echo "Building classifier model with training data ..."
bash bin/mahout trainclassifier -i traininginput -o wikipediamodel -mf 4 -ms 4

echo "Exiting Hadoop ..."
cd ..
bash hadoop-0.20.2/bin/stop-all.sh

