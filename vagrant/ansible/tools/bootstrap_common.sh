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

exit 0
