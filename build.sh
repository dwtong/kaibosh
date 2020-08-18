#!/bin/bash

set -e

# Get App info (which is copied from Distillery documentation)
APP_NAME="$(grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')"
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"
TAR_FILENAME=${APP_NAME}-${APP_VSN}.tar.gz

if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: uncommitted changes." && exit 1
fi

# Build image
docker build -t ${APP_NAME}_server .

# Extract tar
id=$(docker create ${APP_NAME}_server)
echo "$id"
echo "${TAR_FILENAME}"
docker cp $id:/app/${TAR_FILENAME} .
docker rm $id
