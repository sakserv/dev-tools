#!/usr/bin/env bash

#
# Variables
#
ZK_SRC_DIR=/zookeeper_src
ZK_STG_DIR=/zookeeper_staging
ANSIBLE_ZK_STG_DIR=/ansible-zookeeper_staging

#
# Install necessary build deps
#
echo "#### Installing ant-junit, and cppunit-devel"
yum install ant-junit cppunit-devel -y

#
# Building Zookeeper
#
echo "#### Staging code to $ZK_STG_DIR"
if [ -d $ZK_STG_DIR ]; then
  rm -rf $ZK_STG_DIR
fi
mkdir -p $ZK_STG_DIR
cp -Rp $ZK_SRC_DIR/* $ZK_STG_DIR

echo "#### Running the hadoop build"
cd $ZK_STG_DIR && ant clean tar
