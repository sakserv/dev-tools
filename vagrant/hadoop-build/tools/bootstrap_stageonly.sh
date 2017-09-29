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
echo "#### Remving cmake 2"
yum remove cmake -y

echo "#### Installing openssl, cmake3, and protbuf"
yum install openssl-devel cmake3 protobuf-devel -y

echo "#### Add cmake symlink"
ln -s /usr/bin/cmake3 /usr/bin/cmake

#
# Building Hadoop
#
echo "#### Staging code to $HADOOP_STG_DIR"
if [ -d $HADOOP_STG_DIR ]; then
  rm -rf $HADOOP_STG_DIR
fi
mkdir -p $HADOOP_STG_DIR
cp -Rp $HADOOP_SRC_DIR/* $HADOOP_STG_DIR

exit 0
