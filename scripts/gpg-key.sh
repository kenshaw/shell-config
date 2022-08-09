#!/bin/bash

APT=apt-get
APTITUDE=$(type -p aptitude)
if [ ! -z "$APTITUDE" ]; then
  APT=$APTITUDE
fi

NAME=$1
KEY=$2
UPDATE=0

OPTIND=1
while getopts "u" opt; do
case "$opt" in
  u) UPDATE=1 ;;
esac
done

if [[ -z "$NAME" || -z "$KEY" ]]; then
  echo "usage: $0 <NAME> <KEY>"
  exit 1
fi

if [ "$USER" != "root" ]; then
  echo "error: not root!"
  exit 1
fi

if [ ! -f /etc/apt/sources.list.d/$NAME.list ]; then
  echo "error: /etc/apt/sources.list.d/$NAME.list does not exist!"
  exit 1
fi

if [ -f /etc/apt/keyrings/$NAME-archive-keyring.gpg ]; then
  echo "error: /etc/apt/keyrings/$NAME-archive-keyring.gpg already exists!"
  exit 1
fi

perl -pi -e "s%^deb http%deb [arch=amd64 signed-by=/etc/apt/keyrings/$NAME-archive-keyring.gpg] http%" /etc/apt/sources.list.d/$NAME.list

(set -x;
  gpg --no-default-keyring --keyring /etc/apt/keyrings/$NAME-archive-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys $KEY
)

if [ "$UPDATE" = "1" ]; then
  (set -x;
    $APT update
  )
fi
