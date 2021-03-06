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

echo "#### Installing git"
yum install git -y

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
yum install docker-engine -y

echo "#### Configuring docker"
mkdir -p /etc/docker
cp /vagrant/files/daemon.json /etc/docker/

echo "#### Starting docker"
systemctl start docker.service

exit 0
