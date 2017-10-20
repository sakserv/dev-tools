#!/usr/bin/env bash

#
# Get release tgz path from cmdline
#
if [ $# -ne 1 ]; then
  echo "ERROR: Must supply path to the release tgz"
  exit 1
fi
RELEASE_TGZ="$1"

#
# Variables
#
HADOOP_SRC_DIR=/hadoop_src
HADOOP_STG_DIR=/hadoop_staging
ANSIBLE_HADOOP_STG_DIR=/ansible-hadoop_staging

echo "#### Staging the hadoop archive"
cp $RELEASE_TGZ /tmp/hadoop.tar.gz

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
