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
yum install docker-engine-1.11.2-1.el7.centos -y

echo "#### Configuring docker"
cp /vagrant/files/docker /etc/sysconfig/docker

echo "#### Configuring docker-storage"
cp /vagrant/files/docker-storage /etc/sysconfig/docker-storage

echo "#### Copy docker daemon systemd unit file"
cp /vagrant/files/docker.service /usr/lib/systemd/system/docker.service

echo "#### Reload unit files"
systemctl daemon-reload

echo "#### Starting docker"
systemctl start docker.service

exit 0
