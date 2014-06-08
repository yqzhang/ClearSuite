#!/bin/bash
#
# Set up CloudSuite Data Analytics
#
# By Matt Skach
#


export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
export BENCHMARK=Data-Analytics

# Check all the required packages and apps.
echo "[Data-Analytics] Checking required packages ...";
REQUIRED_PACKAGES=("git" "sed" "javac" "mvn" "bzip2");
for pkg in "${REQUIRED_PACKAGES[@]}"
do
  if [ ! -e /usr/share/doc/$pkg ] && [ ! -e /usr/bin/$pkg ] ; then
    echo "[Data-Analytics] $pkg is needed, please install it before running this script";
    exit 1;
  fi
done

if [ ! -e $JAVA_HOME ] ; then
  echo "[Data-Analytics] Java is needed, please install it before running this script.";
  echo "[Data-Analytics] If Java is already installed, please update JAVA_HOME in the setup script.";
  exit 1;
fi


# Compatibility with newer asm file path
if [ ! -e /usr/include/asm ] ; then
  sudo ln -s /usr/include/asm-generic /usr/include/asm
fi

# Establish pathes
HOMEPATH=`pwd`
FORMATTEDHADOOPTMPPATH=$(echo "$HOMEPATH/analytics-release/hadoop-0.20.2/tmp" | sed 's/\//\\\//g')
FORMATTEDHADOOPNAMEPATH=$(echo "$HOMEPATH/analytics-release/hadoop-0.20.2/namenode" | sed 's/\//\\\//g')
FORMATTEDHADOOPDATAPATH=$(echo "$HOMEPATH/analytics-release/hadoop-0.20.2/data" | sed 's/\//\\\//g')
FORMATTEDJAVAPATH=$(echo "$JAVA_HOME" | sed 's/\//\\\//g')

# Configure and install.
echo "[Data-Analytics] Setting up Data-Analytics:"
echo "[Data-Analytics] Downloading packages ..."
wget http://parsa.epfl.ch/cloudsuite/software/analytics.tar.gz

echo "[Data-Analytics] Extracting Data-Analytics package ..."
tar -zxvf analytics.tar.gz
rm -rf analytics.tar.gz

echo "[Data-Analytics] Setting up Hadoop..."
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


echo "[Data-Analytics] Starting Hadoop ..."
bash bin/start-all.sh

echo "[Data-Analytics] Setting up Mahout ..."
cd ..
tar -zxvf mahout.tar.gz

cd mahout-distribution-0.6
mvn install -DskipTests


echo "[Data-Analytics] Downloading Wikipedia data ..."
mkdir examples/temp
cd examples/temp
wget download.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2

echo "[Data-Analytics] Extracting Wikipedia data package (slow!) ..."
bunzip2 enwiki-latest-pages-articles.xml.bz2
cd ../..

echo "[Data-Analytics] Chunking Wikipedia data (slow!)..."
bash bin/mahout wikipediaXMLSplitter -d examples/temp/enwiki-latest-pages-articles.xml -o wikipedia/chunks -c 64
echo "[Data-Analytics] Verifying Wikipedia data chunks ..."
bash ../hadoop-0.20.2/bin/hadoop dfs -ls wikipedia/chunks
cd examples/temp
rm enwiki-latest-pages-articles.xml


echo "[Data-Analytics] Downloading Wikipedia training data ..."
wget http://parsa.epfl.ch/cloudsuite/software/enwiki-20100904-pages-articles1.xml.bz2
echo "[Data-Analytics] Extracting Wikipedia training data package (slow!) ..."
bunzip2 enwiki-20100904-pages-articles1.xml.bz2
cd ../..
echo "[Data-Analytics] Chunking Wikipedia training data (slow!)..."
bash bin/mahout wikipediaXMLSplitter -d examples/temp/enwiki-20100904-pages-articles1.xml -o wikipedia-training/chunks -c 64
echo "[Data-Analytics] Verifying Wikipedia training data chunks ..."
bash ../hadoop-0.20.2/bin/hadoop dfs -ls wikipedia-training/chunks
cd examples/temp
rm enwiki-20100904-pages-articles1.xml
cd ../../../..


echo "[Data-Analytics] Copying Wikipedia categories ..."
cp analytics-release/categories.txt analytics-release/mahout-distribution-0.6/examples/temp/categories.txt
cd analytics-release/mahout-distribution-0.6

echo "[Data-Analytics] Creating Wikipedia training data categories ..."
bash bin/mahout wikipediaDataSetCreator -i wikipedia-training/chunks -o traininginput -c examples/temp/categories.txt
echo "[Data-Analytics] Verifying Wikipedia training data categories ..."
bash ../hadoop-0.20.2/bin/hadoop fs -ls traininginput


echo "[Data-Analytics] Creating Wikipedia data categories ..."
bash bin/mahout wikipediaDataSetCreator -i wikipedia/chunks -o wikipediainput -c examples/temp/categories.txt
echo "[Data-Analytics] Verifying Wikipedia data categories ..."
bash ../hadoop-0.20.2/bin/hadoop fs -ls wikipediainput


echo "[Data-Analytics] Building classifier model with training data ..."
bash bin/mahout trainclassifier -i traininginput -o wikipediamodel -mf 4 -ms 4

echo "[Data-Analytics] Exiting Hadoop ..."
cd ..
bash hadoop-0.20.2/bin/stop-all.sh

echo "[Data-Analytics] Recommend running 'killall java' before running the benchmark."
