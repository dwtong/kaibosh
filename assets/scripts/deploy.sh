#!/bin/bash -e

SSH_USER=kaibosh

if [ ! -n "${DEPLOY_TO+set}" ]; then
  echo "Error: No server destination specified."
  exit 1;
fi

if ! cat ~/.ssh/known_hosts | grep -q $DEPLOY_TO; then
  echo "Adding IP to known hosts."
  ssh-keyscan $DEPLOY_TO >> ~/.ssh/known_hosts
fi

echo "Building assets."
npm run build

echo "Syncing files with host."
rsync -avz ./dist/ kaibosh@$DEPLOY_TO:~/public/
