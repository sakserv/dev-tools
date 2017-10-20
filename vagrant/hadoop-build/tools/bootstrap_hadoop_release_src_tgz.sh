#!/usr/bin/env bash

#
# Get release tgz path from cmdline
#
if [ $# -ne 1 ]; then
  echo "ERROR: Must supply path to the release src tgz"
  exit 1
fi
RELEASE_TGZ="$1"

#
# Variables
#
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
tar -xzvf $RELEASE_TGZ --strip 1 -C $HADOOP_STG_DIR

echo "#### Running the hadoop build"
cd $HADOOP_STG_DIR
mvn clean install -Pnative,dist -Dtar -Dcontainer-executor.conf.dir=../etc/hadoop -Dcontainer-executor.additional_cflags="-DDEBUG" -DskipTests -Dmaven.javadoc.skip=true || exit 1

echo "#### Staging the hadoop archive"
cp $HADOOP_STG_DIR/hadoop-dist/target/hadoop-*.tar.gz /tmp/hadoop.tar.gz

#
# Installing and starting Hadoop
#
echo "#### Staging ansible-hadoop"
if [ -d $ANSIBLE_HADOOP_STG_DIR ]; then
  rm -rf $ANSIBLE_HADOOP_STG_DIR
fi
git clone https://github.com/sakserv/ansible-hadoop.git $ANSIBLE_HADOOP_STG_DIR

echo "#### Running the ansible hadoop provisioning playbook"
ansible-playbook --private-key /root/.ssh/ansible -i $ANSIBLE_HADOOP_STG_DIR/inventory $ANSIBLE_HADOOP_STG_DIR/hadoop.yml

exit 0
