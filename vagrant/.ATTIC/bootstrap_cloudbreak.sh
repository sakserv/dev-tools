#!/usr/bin/env bash

PUBLIC_IP=$(ip addr list eth0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1)
INST_DIR="/usr/local/src/cbd-local"
GIT_BRANCH=master
export GIT_ORG=sequenceiq
#export TRACE=1
BIN_URL=


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
cd $INST_DIR && curl https://raw.githubusercontent.com/$GIT_ORG/cloudbreak-deployer/$GIT_BRANCH/install | sh && cbd --version

echo "#### Creating cbd profile"
echo export PUBLIC_IP=$PUBLIC_IP > $INST_DIR/Profile

#echo "#### Running initial cbd init"
#(cd $INST_DIR && cbd init) || exit 1

echo "#### Updating to cloudbreak master"
(cd $INST_DIR && cbd update master) || exit 1

echo "#### Rerunning cbd init"
(cd $INST_DIR && cbd init) || exit 1

echo "#### Starting Cloudbreak"
(cd $INST_DIR && cbd start) || exit 1

exit 0
