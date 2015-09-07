#!/bin/bash

# Clean up
cd /tmp && rm -rf build-tools

# Clone the build tools repo
git clone https://github.com/sakserv/build-tools.git

# Grab the latest kafka-readfile-producer
build-tools/nexus_artifact_download.sh -i "com.github.sakserv:kafka-readfile-producer:0.0.2" -p jar

# Run the producer code
java -cp "/tmp/kafka-readfile-producer-0.0.2.jar:/usr/hdp/current/kafka-broker/libs/kafka_2.10-0.8.2.2.3.0.0-2557.jar" com.github.sakserv.kafka.producer.KafkaReadfileProducerCli /tmp/build-tools/conf/sandbox.properties /tmp/build-tools/samples/kafka_readfile_producer_input.txt
