#!/usr/bin/env bash

#
# Variables
#
HADOOP_STG_DIR=/hadoop_staging_testpatch
HADOOP_TRUNK="https://github.com/apache/hadoop.git"
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
git clone $HADOOP_TRUNK $HADOOP_STG_DIR

exit 0
