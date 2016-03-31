#!/usr/bin/env bash

#
# Variables
#
GOPATH=/go
GOINSTPATH=/usr/local
GOROOT=$GOINSTPATH/go
GOTARBALLURL=https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
GOTARBALLLOCAL=/tmp/go.tar.gz

#
# Setup
#
echo -e "\n#### Creating $GOPATH if needed"
if [ ! -d $GOPATH ]; then
  mkdir -p $GOPATH
fi

echo -e "\n#### Creating $GOINSTPATH if needed"
if [ ! -d $GOINSTPATH ]; then
  mkdir -p $GOINSTPATH
fi

#
# Main
#
echo -e "\n#### Install wget"
yum install wget -y

echo -e "\n#### Downloading the go release"
wget $GOTARBALLURL -O $GOTARBALLLOCAL || exit 1

echo -e "\n#### Extracting the go release to $GOINSTPATH"
tar -C $GOINSTPATH -xzf $GOTARBALLLOCAL || exit 1

echo -e "\n#### Adding GOROOT to profile"
echo "export GOROOT=$GOROOT" >>/etc/profile

echo -e "\n#### Adding GOPATH to profile"
echo "export GOPATH=$GOPATH" >>/etc/profile

echo -e "\n#### Adding GOROOT/bin to PATH"
echo "export PATH=$GOROOT/bin" >>/etc/profile

echo -e "\n#### Sourcing the updated profile"
. /etc/profile

echo -e "\n#### Installing go dev tooling (golint, godep, etc)"
go get github.com/tools/godep github.com/golang/lint/golint 

exit 0
