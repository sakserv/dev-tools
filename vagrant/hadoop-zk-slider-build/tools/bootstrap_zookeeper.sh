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
yum install ant-junit cppunit-devel -y || exit 1

#
# Building Zookeeper
#
echo "#### Staging code to $ZK_STG_DIR"
if [ -d $ZK_STG_DIR ]; then
  rm -rf $ZK_STG_DIR
fi
mkdir -p $ZK_STG_DIR
cp -Rp $ZK_SRC_DIR/* $ZK_STG_DIR

echo "#### Running the zookeeper build"
cd $ZK_STG_DIR && ant clean tar || exit 1

echo "#### Staging the zookeeper archive"
cp $ZK_STG_DIR/build/zookeeper-*.tar.gz /tmp/zookeeper.tar.gz || exit 1

#
# Installing and starting Zookeeper
#
echo "#### Staging ansible-zookeeper"
if [ -d $ANSIBLE_ZK_STG_DIR ]; then
  rm -rf $ANSIBLE_ZK_STG_DIR
fi
git clone https://github.com/sakserv/ansible-zookeeper.git $ANSIBLE_ZK_STG_DIR || exit 1

echo "#### Running the ansible zookeeper provisioning playbook"
ansible-playbook --private-key /root/.ssh/ansible -i $ANSIBLE_ZK_STG_DIR/inventory $ANSIBLE_ZK_STG_DIR/zookeeper.yml || exit 1

exit 0
