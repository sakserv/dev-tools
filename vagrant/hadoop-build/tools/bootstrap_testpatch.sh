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
echo "#### Installing build deps"
yum install openssl-devel cmake protobuf-devel nodejs -y

#
# Install and configure bower
#
echo "#### Installing and configuring bower"
npm install -g bower
echo '{ "allow_root": true }' > /root/.bowerrc

#
# Stage a clean hadoop repo for test-patch
#
echo "#### Staging code to $HADOOP_STG_DIR"
if [ -d $HADOOP_STG_DIR ]; then
  rm -rf $HADOOP_STG_DIR
fi
git clone $HADOOP_TRUNK $HADOOP_STG_DIR

exit 0
