#!/bin/bash -e

RELEASE_DIR=/src/kaibosh/$VERSION_NAME
RELEASE_SYMLINK=/src/kaibosh/latest

ASSETS=$RELEASE_DIR/lib/kaibosh-0.1.0/priv/static
ASSETS_SYMLINK=/src/kaibosh/public

PREVIOUS_RELEASE_DIR=$(readlink /src/kaibosh/latest)

export $(sudo cat /src/kaibosh/.env | xargs)
export RELEASE_DIR=/src/kaibosh/$VERSION_NAME

echo "Extracting release on host."
mkdir -p $RELEASE_DIR/tmp/
tar -xf /src/kaibosh/$VERSION_NAME.tar.gz -C $RELEASE_DIR
rm /src/kaibosh/$VERSION_NAME.tar.gz

echo "Updating permissions for deploy user."
sudo chown -R deploy:deploy $RELEASE_DIR
sudo chmod a=rx $RELEASE_DIR

echo "Restarting Kaibosh app and updating symlinks."
sudo systemctl stop kaibosh

ln -sfn $RELEASE_DIR $RELEASE_SYMLINK
ln -sfn $ASSETS $ASSETS_SYMLINK

sudo systemctl start kaibosh

echo "Removing previous release."
sudo rm -rf $PREVIOUS_RELEASE_DIR
