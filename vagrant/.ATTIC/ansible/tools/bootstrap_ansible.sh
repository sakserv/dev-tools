#!/usr/bin/env bash

#
# Base package setup
#
echo "#### Installing ansible"
yum install ansible -y

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
