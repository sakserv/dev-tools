#!/usr/bin/env bash

adapter="eth1"

#
# Install bridge-utils
#
echo "#### Installing bridge-utils"
yum install bridge-utils -y

#
# Create the bridge
#
echo "#### Creating br0"
brctl addbr br0

#
# Add adapter to the bridge
#
echo "#### Adding $adapter to br0"
brctl addif br0 $adapter

#
# Remove the IP from adapter
#
ip=$(ip addr show $adapter | grep -E inet.*${adapter} | awk '{print $2}')
ip addr del $ip dev $adapter

#
# Run dhclient to get an IP on the bridge
#
dhclient br0
