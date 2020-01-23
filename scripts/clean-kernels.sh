#!/bin/bash

CURRENT=$(uname -r | sed -e 's/-\(generic\|amd64\)$//')
GENERIC=$(apt-cache depends linux-image-generic|grep '^  Depends:'|awk -F: '{print $2}'|sed -e 's/\s//g'|grep 'linux-image-'|cut -d- -f 3,4)
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
    aptitude install linux-generic linux-image-generic linux-headers-generic $REMOVE
  )
else
  echo "NOTHING DONE! -- try --clean=yes"
fi
