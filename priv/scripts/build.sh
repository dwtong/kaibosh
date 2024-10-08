#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR/../../

if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: uncommitted changes." && exit 1
fi

if [ ! -n "${APP_NAME+set}" ]; then
  echo "Error: No app name specified."
  exit 1;
fi

# Build image
docker build -t ${APP_NAME}_server .

# Extract tar
id=$(docker create ${APP_NAME}_server)
echo "$id"
mkdir -p tmp
docker cp $id:/app/kaibosh.tar.gz ./tmp/$APP_NAME.tar.gz
docker rm $id

cd -
