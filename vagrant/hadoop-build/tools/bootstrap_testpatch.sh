#!/usr/bin/env bash

#
# Variables
#
HADOOP_STG_DIR=/hadoop_staging_testpatch
HADOOP_TRUNK="https://github.com/apache/hadoop.git"
ANSIBLE_HADOOP_STG_DIR=/ansible-hadoop_staging
FB_DL='https://downloads.sourceforge.net/project/findbugs/findbugs/3.0.1/findbugs-3.0.1.tar.gz?r=http%3A%2F%2Ffindbugs.sourceforge.net%2Fdownloads.html&ts=1502194627&use_mirror=superb-dca2'
FB_HOME=/opt/findbugs
FB_STAGE_DIR=/tmp/findbugs_staging

#
# Installing required build deps
#
echo "#### Remving cmake 2"
yum remove cmake -y

echo "#### Installing openssl, cmake3, and protbuf"
yum install openssl-devel cmake3 protobuf-devel nodejs -y

echo "#### Add cmake symlink"
ln -s /usr/bin/cmake3 /usr/bin/cmake

#
# Install and configure bower
#
echo "#### Installing and configuring bower"
npm install -g bower
echo '{ "allow_root": true }' > /root/.bowerrc

#
# Install and configure findbugs
#
if [ -d "$FB_STAGE_DIR" ]; then
  rm -rf $FB_STAGE_DIR
fi
mkdir $FB_STAGE_DIR

if [ -d "$FB_HOME" ]; then
  rm -rf $FB_HOME
fi
mkdir $FB_HOME

cd $FB_STAGE_DIR
wget "$FB_DL" -O $FB_STAGE_DIR/findbugs.tar.gz
tar --strip-components=1 -xvf findbugs.tar.gz -C $FB_HOME
echo "export FINDBUGS_HOME=$FB_HOME" >> /etc/profile
echo "export PATH=$PATH:$FB_HOME" >> /etc/profile

#
# Stage a clean hadoop repo for test-patch
#
echo "#### Staging code to $HADOOP_STG_DIR"
if [ -d $HADOOP_STG_DIR ]; then
  rm -rf $HADOOP_STG_DIR
fi
git clone $HADOOP_TRUNK $HADOOP_STG_DIR

exit 0
