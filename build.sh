#!/bin/bash

set -e

if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: uncommitted changes." && exit 1
fi

# Build image
docker build -t ${APP_NAME}_server .

# Extract tar
id=$(docker create ${APP_NAME}_server)
echo "$id"
docker cp $id:/app/kaibosh.tar.gz ./$APP_NAME.tar.gz
docker rm $id
