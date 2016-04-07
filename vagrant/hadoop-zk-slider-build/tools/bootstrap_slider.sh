#!/usr/bin/env bash

#
# Variables
#
SLIDER_SRC_DIR=/slider_src
SLIDER_STG_DIR=/slider_staging
ANSIBLE_SLIDER_STG_DIR=/ansible-slider_staging

#
# Install necessary build deps
#
echo "#### Installing protobuf"
yum install protobuf-devel -y

#
# Building Slider
#
echo "#### Staging code to $SLIDER_STG_DIR"
if [ -d $SLIDER_STG_DIR ]; then
  rm -rf $SLIDER_STG_DIR
fi
mkdir -p $SLIDER_STG_DIR
cp -Rp $SLIDER_SRC_DIR/* $SLIDER_STG_DIR

echo "#### Running the slider build"
cd $SLIDER_STG_DIR && mvn clean site:site site:stage package -DskipTests

echo "#### Staging the slider archive"
cp $SLIDER_STG_DIR/slider-assembly/target/slider*all.tar.gz /tmp/slider.tar.gz

#
# Installing and starting Slider
#
echo "#### Staging ansible-slider"
if [ -d $ANSIBLE_SLIDER_STG_DIR ]; then
  rm -rf $ANSIBLE_SLIDER_STG_DIR
fi
git clone https://github.com/sakserv/ansible-slider.git $ANSIBLE_SLIDER_STG_DIR

echo "#### Running the ansible slider provisioning playbook"
ansible-playbook --private-key /root/.ssh/ansible -i $ANSIBLE_SLIDER_STG_DIR/inventory $ANSIBLE_SLIDER_STG_DIR/slider.yml

exit 0
