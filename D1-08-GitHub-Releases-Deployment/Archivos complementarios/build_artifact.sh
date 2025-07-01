#!/bin/bash
set -e
echo "Creating a dummy build artifact..."
DATE=$(date +%s)
echo "Build artifact content for release $DATE" > release_artifact.txt
echo "Artifact created: release_artifact.txt"
