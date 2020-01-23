#!/bin/bash

TYPE=$(dpkg --get-selections|egrep '^linux-image-(generic|virtual)'|sed -e 's/.*\(generic\|virtual\).*/\1/'|tail -1)

if [[ "$TYPE" != "virtual" && "$TYPE" != "generic" ]]; then
  echo "ERROR: not able to determine linux image type"
  exit
fi

CURRENT=$(uname -r | sed -e 's/-\(generic\|amd64\)$//')
GENERIC=$(apt-cache depends linux-image-$TYPE|grep '^  Depends:'|awk -F: '{print $2}'|sed -e 's/\s//g'|grep 'linux-image-'|cut -d- -f 3,4)
REMOVE=$(dpkg --get-selections | \
  egrep '^linux-.*-[0-9]\.[0-9]+\.[0-9]+-[0-9]+' | \
  sed -e 's/\s*\(install\|deinstall\|purge\)$//' | \
  grep -v $CURRENT | \
  grep -v $GENERIC | \
  sed -e ':a;N;$!ba;s/\n/_ /g')

set -e

echo "CURRENT: $CURRENT"
echo "GENERIC: $GENERIC"
echo "REMOVE:  $REMOVE"

if [ "$USER" != "root" ]; then
  echo "not root!"
  exit
fi

if [ "$1" == "--clean=yes" ]; then
  (set -x;
    aptitude install linux-$TYPE linux-image-$TYPE linux-headers-$TYPE $REMOVE
  )
else
  echo "NOTHING DONE! -- try --clean=yes"
fi
