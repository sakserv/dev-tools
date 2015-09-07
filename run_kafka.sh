#!/bin/bash

# Clone the build tools repo
cd /tmp && git clone https://github.com/sakserv/build-tools.git

# Grab the latest kafka-readfile-producer
build-tools/latest_sonatype_snapshot.sh com.github.sakserv kafka-readfile-producer 0.0.2

# Run the producer code
java -cp "/tmp/kafka-readfile-producer-0.0.2.jar:/usr/hdp/current/kafka-broker/libs/kafka_2.10-0.8.2.2.3.0.0-2557.jar" com.github.sakserv.kafka.producer.KafkaReadfileProducerCli /tmp/build-tools/conf/sandbox.properties /tmp/build-tools/samples/kafka_readfile_producer_input.txt
