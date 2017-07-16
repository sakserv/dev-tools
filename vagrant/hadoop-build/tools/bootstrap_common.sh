#!/usr/bin/env bash

#
# Base package setup
#
echo "#### Running yum update"
yum update -y

echo "#### Installing the EPEL repo"
yum install epel-release -y

echo "#### Installing development tooling"
yum groupinstall 'Development Tools' -y

echo "#### Installing java8, git, ansible, etc"
yum install java-1.8.0-openjdk-devel git ansible gcc-c++ cmake strace wget psmisc lsof -y

echo "#### Adding JAVA_HOME to profile"
# Determine JAVA_HOME
WHICH_JAVA=$(which java)
if [ $? -ne 0 ]; then
  echo "ERROR: Could not find java, is it installed?"
  exit 1
fi
ALTERNATIVES_JAVA=$(readlink $WHICH_JAVA)
JAVA_HOME=$(readlink $ALTERNATIVES_JAVA | sed 's|jre/bin/java||g')
echo "export JAVA_HOME=$JAVA_HOME" >>/etc/profile

#
# Install Maven
#
echo -e "\n#### Installing Maven"
cd /tmp
wget -N http://apache.cs.utah.edu/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
tar -xzvf apache-maven-3.5.0-bin.tar.gz -C /usr/local/bin
export M2_HOME=/usr/local/bin/apache-maven-3.5.0/
export M2=$M2_HOME/bin
export JAVA_HOME=$JAVA_HOME
export PATH=$PATH:$M2:$JAVA_HOME/bin
echo "export PATH=$PATH:$M2:$JAVA_HOME/bin" >>/etc/profile
. /etc/profile
mvn --version

#
# Docker setup
#
echo "#### Install the docker repo"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

echo "#### Installing docker"
yum install docker-engine-1.12.5-1.el7.centos -y

echo "#### Configuring docker"
mkdir -p /etc/docker
cp /vagrant/files/daemon.json /etc/docker

echo "#### Starting docker"
systemctl start docker.service

#
# Maven setup
#
echo "#### Configuring maven settings"
mkdir -p /root/.m2/
cp /vagrant/files/settings.xml /root/.m2/

#
# Ansible setup
#
echo "#### Creating SSH key for ansible"
ssh-keygen -f /root/.ssh/ansible -N ''

echo "#### Adding ssh key to authorized_keys"
cat /root/.ssh/ansible.pub >> /root/.ssh/authorized_keys

echo "#### Adding ansible.cfg to avoid host key checking"
cp /vagrant/files/.ansible.cfg /root/

echo "#### Run vi mode"
echo "set -o vi" >> /root/.bashrc

exit 0
