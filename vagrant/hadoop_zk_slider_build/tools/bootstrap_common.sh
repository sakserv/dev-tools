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

echo "#### Installing java8, git, maven, ansible, openssl, cmake, and protbuf"
yum install java-1.8.0-openjdk-devel git maven ansible openssl-devel cmake protobuf-devel -y

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
yum install docker -y
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

exit 0
