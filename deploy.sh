#!/bin/bash -e

SSH_USER=kaibosh
RELEASE_VERSION=0.1.0

if [ ! -n "${DEPLOY_TO+set}" ]; then
  echo "Error: No server destination specified."
  exit 1;
fi

if ! cat ~/.ssh/known_hosts | grep -q $DEPLOY_TO; then
  echo "Adding IP to known hosts."
  ssh-keyscan $DEPLOY_TO >> ~/.ssh/known_hosts
fi

echo "Building release."
./build.sh

echo "Syncing files with host."
scp kaibosh-$RELEASE_VERSION.tar.gz kaibosh@$DEPLOY_TO:/src/kaibosh

echo "Running release script on production machine."
ssh kaibosh@$DEPLOY_TO "RELEASE_VERSION=$RELEASE_VERSION bash -s" < release.sh
