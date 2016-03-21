#!/usr/bin/env bash

# Variables
HADOOP_SRC_DIR=/hadoop_src
HADOOP_STG_DIR=/hadoop_staging

echo "#### Running yum update"
yum update -y

echo "#### Installing the EPEL repo"
yum install epel-release -y

echo "#### Install the docker repo"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

echo "#### Installing development tooling"
yum groupinstall 'Development Tools' -y

echo "#### Installing java8, git, maven, ansible, openssl, cmake, docker and protbuf"
yum install java-1.8.0-openjdk-devel git maven ansible openssl-devel cmake protobuf-devel docker-engine -y

echo "#### Starting docker"
systemctl start docker.service

echo "#### Configuring maven settings"
mkdir -p /root/.m2/ 
cp /vagrant/settings.xml /root/.m2/

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

echo "#### Downloading the ansible hadoop playbook"
cd /vagrant && git clone https://github.com/sakserv/ansible-hadoop.git

echo "#### Creating SSH key for ansible"
ssh-keygen -f /root/.ssh/ansible -N ''

echo "#### Adding ssh key to authorized_keys"
cat /root/.ssh/ansible.pub >> /root/.ssh/authorized_keys

echo "#### Adding ansible.cfg to avoid host key checking"
cp /vagrant/.ansible.cfg /root/

echo "#### Running the ansible hadoop provisioning playbook"
ansible-playbook --private-key /root/.ssh/ansible -i /vagrant/ansible-hadoop/inventory /vagrant/ansible-hadoop/hadoop.yml

echo "#### Adding the hadoop binaries to PATH"
echo "export PATH=$PATH:/usr/local/src/hadoop_install/hadoop/bin/" >>/etc/profile

echo "#### Adding JAVA_HOME to profile"
# Determine JAVA_HOME
WHICH_JAVA=$(which java)
if [ $? -ne 0 ]; then
  echo "ERROR: Could not find java, is it installed?"
  exit 1
fi
ALTERNATIVES_JAVA=$(readlink $WHICH_JAVA)
JAVA_HOME=$(readlink $ALTERNATIVES_JAVA | sed 's|bin/java||g')
echo "export JAVA_HOME=$JAVA_HOME" >>/etc/profile

exit 0
