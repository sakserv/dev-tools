#!/usr/bin/env bash

#
# Variables
#
HADOOP_SRC_DIR=/hadoop_src
HADOOP_STG_DIR=/hadoop_staging
ANSIBLE_HADOOP_STG_DIR=/ansible-hadoop_staging

#
# Installing required build deps
#
echo "#### Installing openssl, cmake, and protbuf"
yum install openssl-devel cmake protobuf-devel -y

#
# Building Hadoop
#
echo "#### Staging code to $HADOOP_STG_DIR"
if [ -d $HADOOP_STG_DIR ]; then
  rm -rf $HADOOP_STG_DIR
fi
mkdir -p $HADOOP_STG_DIR
cp -Rp $HADOOP_SRC_DIR/* $HADOOP_STG_DIR

echo "#### Running the hadoop build"
cd $HADOOP_STG_DIR 
mvn clean install -Pnative,dist -Dtar -Dcontainer-executor.conf.dir=../etc/hadoop -Dcontainer-executor.additional_cflags="-DDEBUG" -DskipTests -Dmaven.javadoc.skip=true || exit 1

echo "#### Staging the hadoop archive"
cp $HADOOP_STG_DIR/hadoop-dist/target/hadoop-*.tar.gz /tmp/hadoop.tar.gz

exit 0
