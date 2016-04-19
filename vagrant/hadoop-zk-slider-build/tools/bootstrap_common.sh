#!/usr/bin/env bash

#
# Base package setup
#
echo "#### Running yum update"
yum update -y || exit 1

echo "#### Installing the EPEL repo"
yum install epel-release -y || exit 1

echo "#### Installing development tooling"
yum groupinstall 'Development Tools' -y || exit 1

echo "#### Installing java8, git, maven, ansible"
yum install java-1.8.0-openjdk-devel git maven ansible -y || exit 1

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
yum install docker-engine -y || exit 1

echo "#### Configuring docker"
cp /vagrant/files/docker /etc/sysconfig/docker || exit 1

echo "#### Configuring docker-storage"
cp /vagrant/files/docker-storage /etc/sysconfig/docker-storage || exit 1

echo "#### Starting docker"
systemctl start docker.service 

#
# Maven setup
#
echo "#### Configuring maven settings"
mkdir -p /root/.m2/
cp /vagrant/files/settings.xml /root/.m2/ || exit 1

#
# Ansible setup
#
echo "#### Creating SSH key for ansible"
ssh-keygen -f /root/.ssh/ansible -N '' || exit 1

echo "#### Adding ssh key to authorized_keys"
cat /root/.ssh/ansible.pub >> /root/.ssh/authorized_keys || exit 1

echo "#### Adding ansible.cfg to avoid host key checking"
cp /vagrant/files/.ansible.cfg /root/ || exit 1

exit 0
