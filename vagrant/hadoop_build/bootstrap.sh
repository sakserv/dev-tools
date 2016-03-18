#!/usr/bin/env bash

echo "#### Running yum update"
yum update -y

echo "#### Installing the EPEL repo"
yum install epel-release -y

echo "#### Installing development tooling"
yum groupinstall 'Development Tools' -y

echo "#### Installing java8, git, maven, ansible, openssl, cmake and protbuf"
yum install java-1.8.0-openjdk-devel git maven ansible openssl-devel cmake protobuf-devel -y

echo "#### Configuring maven settings"
mkdir -p /root/.m2/ 
cp /vagrant/settings.xml /root/.m2/

echo "#### Running the hadoop build"
cd /git && mvn clean install package -Pnative,dist -Dtar -Dcontainer-executor.conf.dir=../etc/hadoop -DskipTests -Dmaven.javadoc.skip=true

echo "#### Staging the hadoop archive"
cp /git/hadoop-dist/target/hadoop-*.tar.gz /tmp/hadoop.tar.gz

echo "#### Creating SSH key for ansible"
ssh-keygen -f /root/.ssh/ansible -N ''

echo "#### Adding ssh key to authorized_keys"
cat /root/.ssh/ansible.pub >> /root/.ssh/authorized_keys

echo "#### Running the ansible hadoop provisioning playbook"
ansible-playbook --private-key /root/.ssh/ansible -i /vagrant/ansible-hadoop/inventory /vagrant/ansible-hadoop/hadoop.yml

exit 0
