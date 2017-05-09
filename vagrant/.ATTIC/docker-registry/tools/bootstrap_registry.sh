#!/bin/bash

#
# Create the self signed cert
#
mkdir -p /data/certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout /data/certs/domain.key -x509 -days 365 -out /data/certs/domain.crt -subj "/C=US/ST=CA/L=Santa Clara/O=Hortonworks/OU=docker/CN=hwxdev.site"

#
# Copy the cert for the docker daemon
#
mkdir -p /etc/docker/certs.d/hwxdev.site:5000/
cp /data/certs/domain.crt /etc/docker/certs.d/hwxdev.site:5000/ca.crt

#
# Start docker
#
systemctl start docker.service

#
# Start the registry
#
mkdir -p /data/registry
docker run -d -p 5000:5000 --restart=always --name registry \
	-v /data/registry:/var/lib/registry \
	-v /data/certs:/certs \
	-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
	-e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
        -e REGISTRY_HTTP_SECRET="shhitsasecret" \
	registry:2
