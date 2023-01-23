#!/bin/bash

OLD_VERSION="v$(geckodriver -V | sed -n 1p | sed -e 's/ //g' | sed -e 's/geckodriver//g' | sed -e 's/(.*)//g')"
VERSION=$(curl --silent https://api.github.com/repos/mozilla/geckodriver/releases/latest | jq .tag_name -r)
DESTINATION="/usr/local/bin/geckodriver"

if $OLD_VERSION != "$VERSION"; then
  echo "Update found!"
  curl -L "https://github.com/mozilla/geckodriver/releases/download/${VERSION}/geckodriver-${VERSION}-linux64.tar.gz" -o /tmp/geckodriver.latest.tar.gz
  sleep 5
  CURRENTDIR=$(pwd)
  cd /tmp && tar xvf geckodriver.latest.tar.gz
  sleep 5
  cd "${CURRENTDIR}" || exit
  sudo cp /tmp/geckodriver ${DESTINATION}
  sudo rm -f /tmp/geckodriver*
  sudo chmod 755 ${DESTINATION}
else
  echo "No update required."
fi
