#!/bin/bash -e

SSH_USER=kaibosh
VERSION_NAME="kaibosh-$(git rev-parse --short HEAD)"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -n "${DEPLOY_TO+set}" ]; then
  echo "Error: No server destination specified."
  exit 1;
fi

if ! cat ~/.ssh/known_hosts | grep -q $DEPLOY_TO; then
  echo "Adding IP to known hosts."
  ssh-keyscan $DEPLOY_TO >> ~/.ssh/known_hosts
fi

echo "Building release."
APP_NAME=$VERSION_NAME $SCRIPT_DIR/build.sh

echo "Syncing files with host."
scp tmp/$VERSION_NAME.tar.gz kaibosh@$DEPLOY_TO:/src/kaibosh

echo "Running release script on production machine."
ssh kaibosh@$DEPLOY_TO "VERSION_NAME=$VERSION_NAME bash -s" < $SCRIPT_DIR/release.sh

echo "Running migrations on production machine."
ssh kaibosh@$DEPLOY_TO "sudo /src/kaibosh/latest/lib/kaibosh-0.1.0/priv/scripts/migrate.sh"
