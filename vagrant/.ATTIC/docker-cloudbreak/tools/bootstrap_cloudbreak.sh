#!/usr/bin/env bash

PUBLIC_IP=$(ip addr list eth0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1)
INST_DIR="/usr/local/src/cbd-local"
GIT_BRANCH=master
export GIT_ORG=sequenceiq
export PATH=$PATH:$INST_DIR

#
# Disable selinux
# 
echo "#### Disabling SELinux for docker volumes"
setenforce 0

#
# Install cbd
#
echo "#### Creating $INST_DIR"
if [ -d $INST_DIR ]; then
  echo "$INST_DIR already exists... removing"
  rm -rf $INST_DIR
fi
mkdir -p $INST_DIR || exit 1

echo "#### Install cbd"
cd $INST_DIR && curl -L s3.amazonaws.com/public-repo-1.hortonworks.com/HDP/cloudbreak/cloudbreak-deployer_snapshot_$(uname)_x86_64.tgz | tar -xz && cbd --version

echo "#### Creating cbd profile"
echo export PUBLIC_IP=$PUBLIC_IP > $INST_DIR/Profile

echo "#### Rerunning cbd init"
(cd $INST_DIR && cbd init) || exit 1

echo "#### Starting Cloudbreak"
(cd $INST_DIR && cbd start) || exit 1

echo "#### Updating PATH with location to cbd"
echo "export PATH=$PATH:$INST_DIR" >> /etc/profile

echo "#### Restart cloudbreak, running kill"
(cd $INST_DIR && cbd kill) || exit 1

echo "#### Restart cloudbreak, running start"
(cd $INST_DIR && cbd start) || exit 1

exit 0
