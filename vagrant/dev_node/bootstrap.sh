#!/usr/bin/env bash

echo "#### Running yum update"
yum update -y

echo "#### Installing the EPEL repo"
yum install epel-release -y

echo "#### Installing development tooling"
yum groupinstall 'Development Tools' -y

echo "#### Installing java8, git, maven, ansible, openssl and protbuf"
yum install java-1.8.0-openjdk-devel git maven ansible, openssl protobuf-devel -y

echo "#### Configuring maven settings"
mkdir -p /root/.m2/ 
cp /vagrant/settings.xml /root/.m2/

# Building on vbox shared folders is iffy at best
# localize the code to the VM
echo "#### Localizing /git"
mkdir -p /git_local && cp -Rp /git/* /git_local/
