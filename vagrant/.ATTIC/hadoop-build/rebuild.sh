#!/bin/bash

HADOOP_SRC_DIR=/hadoop_src
HADOOP_STG_DIR=/hadoop_staging

echo "#### Staging code to $HADOOP_STG_DIR"
if [ -d $HADOOP_STG_DIR ]; then
  rm -rf $HADOOP_STG_DIR
fi
mkdir -p $HADOOP_STG_DIR
cp -Rp $HADOOP_SRC_DIR/* $HADOOP_STG_DIR

echo "#### Running the hadoop build"
cd $HADOOP_STG_DIR && mvn clean install package -Pnative,dist -Dtar -Dcontainer-executor.conf.dir=../etc/hadoop -DskipTests -Dmaven.javadoc.skip=true

echo "#### Staging the hadoop archive"
cp $HADOOP_STG_DIR/hadoop-dist/target/hadoop-*.tar.gz /tmp/hadoop.tar.gz

echo "#### Redownload the ansible playbook"
cd /vagrant && git clone https://github.com/sakserv/ansible-hadoop.git

echo "#### Running the ansible hadoop provisioning playbook"
ansible-playbook --private-key /root/.ssh/ansible -i /vagrant/ansible-hadoop/inventory /vagrant/ansible-hadoop/hadoop.yml

echo "#### Cleaning up the staged ansible playbook"
if [ -d /vagrant/ansible-hadoop ]; then
  rm -rf /vagrant/ansible-hadoop
fi
