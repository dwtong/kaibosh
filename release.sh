#!/bin/bash -e

RELEASE_DIR=/src/kaibosh/$RELEASE_VERSION
RELEASE_SYMLINK=/src/kaibosh/latest

ASSETS=$RELEASE_DIR/lib/kaibosh-0.1.0/priv/static
ASSETS_SYMLINK=/src/kaibosh/public


mkdir -p $RELEASE_DIR/tmp/
tar -xf /src/kaibosh/kaibosh-$RELEASE_VERSION.tar.gz -C $RELEASE_DIR
rm /src/kaibosh/kaibosh-$RELEASE_VERSION.tar.gz

sudo chown -R deploy:deploy $RELEASE_DIR
sudo chmod a=rx $RELEASE_DIR

sudo systemctl stop kaibosh

ln -sfn $RELEASE_DIR $RELEASE_SYMLINK
ln -sfn $ASSETS $ASSETS_SYMLINK

sudo systemctl start kaibosh
