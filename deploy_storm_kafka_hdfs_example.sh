#!/bin/bash

# Clean up
cd /tmp && rm -rf build-tools

# Clone the build tools repo
git clone https://github.com/sakserv/build-tools.git

# Grab the latest kafka-readfile-producer
build-tools/nexus_artifact_download.sh -i "com.github.sakserv:storm-kafka-hdfs-example:0.0.2-SNAPSHOT" -p jar

# Run the producer code
storm jar /tmp/storm-kafka-hdfs-example-0.0.2-SNAPSHOT com.github.sakserv.KafkaHdfsTopology /tmp/build-tools/conf/sandbox.properties
