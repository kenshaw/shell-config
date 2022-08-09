#!/bin/bash

APT=apt-get
APTITUDE=$(type -p aptitude)
if [ ! -z "$APTITUDE" ]; then
  APT=$APTITUDE
fi

TYPE=$(dpkg --get-selections|egrep '^linux-image-(generic|virtual)'|sed -e 's/.*\(generic\|virtual\).*/\1/'|tail -1)

if [[ "$TYPE" != "virtual" && "$TYPE" != "generic" ]]; then
  echo "error: not able to determine linux image type!"
  exit 1
fi

CURRENT=$(uname -r | sed -e 's/-\(generic\|amd64\)$//')
GENERIC=$(apt-cache depends linux-image-$TYPE|grep '^ .Depends:'|awk -F: '{print $2}'|sed -e 's/\s//g'|grep 'linux-image-[0-9]'|cut -d- -f 3,4)
REMOVE=$(dpkg --get-selections | \
  egrep '^linux-.*-[0-9]\.[0-9]+\.[0-9]+-[0-9]+' | \
  sed -e 's/\s*\(install\|deinstall\|purge\)$//' | \
  grep -v $CURRENT | \
  grep -v $GENERIC | \
  sed -e ':a;N;$!ba;s/\n/_ /g')

if [ ! -z "$REMOVE" ]; then
  REMOVE="${REMOVE}_"
fi

set -e

echo "CURRENT: $CURRENT"
echo "GENERIC: $GENERIC"
echo "REMOVE:  $REMOVE"

if [ "$1" == "--clean=yes" ]; then
  if [ "$USER" != "root" ]; then
    echo "error: not root!"
    exit 1
  fi

  (set -x;
    $APT install linux-$TYPE linux-image-$TYPE linux-headers-$TYPE $REMOVE
  )
else
  echo "NOTHING DONE! -- try --clean=yes"
fi
