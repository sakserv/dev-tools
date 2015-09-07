#!/bin/bash

#
# Source the env file
#
source ./.latest_sonatype_snapshot.env

#
# Usage
#
usage() {
echo "$(basename $0) <groupId> <artifactId> <version>"
}

#
# Parse command line args
#
if [ $# -ne 3 ]; then
  usage
  exit 1
fi

groupId="$1"
artifactId="$2"
version="$3"

#
# Set repo URL
#

# If artifact has SNAPSHOT in the name, 
# use the snapshot repo, else use the releases repo.
if echo $version | grep -qi SNAPSHOT; then
  REPO_URL=$BASE_REPO_URL/$SNAPSHOT_POSTFIX
else
  REPO_URL=$BASE_REPO_URL/$RELEASE_POSTFIX
fi

# Append the groupId
REPO_URL=$REPO_URL/$(echo $groupId | sed 's|\.|\/|g')

# Append the artifactId and version
REPO_URL=$REPO_URL/$artifactId/$version

echo $REPO_URL
