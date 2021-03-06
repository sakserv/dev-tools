#!/usr/bin/env bash

#
# Variables
#
HADOOP_SRC_DIR=/hadoop_src
HADOOP_STG_DIR=/hadoop_staging
ANSIBLE_HADOOP_STG_DIR=/ansible-hadoop_staging
MVN_BIN=/usr/local/bin/apache-maven-3.5.2/bin

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

echo "#### Running the hadoop build"
cd $HADOOP_STG_DIR 
$MVN_BIN/mvn clean install -Pnative,dist -Dtar -Dcontainer-executor.conf.dir=../etc/hadoop -DskipTests -Dmaven.javadoc.skip=true || exit 1

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

echo "#### Restarting yarn"
source /usr/local/src/hadoop_install/hadoop/env.sh
/usr/local/src/hadoop_install/hadoop/restart-yarn.sh


exit 0
