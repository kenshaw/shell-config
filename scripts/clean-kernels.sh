#!/bin/bash

KERNEL=`uname -r | sed -e 's/-\(generic\|amd64\)$//'`

TOREMOVE=`dpkg --get-selections | grep 'install$'|egrep 'linux(-signed)?-(image|headers)' | sed -e 's/\s*\(de\)\?install$//' | egrep -v '^linux(-signed)?-(image|headers)-(amd64|generic|virtual)$' | grep -v $KERNEL| tr "\\n" " "`

echo "KERNEL: $KERNEL"
echo "REMOVING: $TOREMOVE"

if [ "$USER" != "root" ]; then
  echo "not root!"
  exit
fi

if [ "$1" == "--clean=yes" ]; then
  aptitude purge $TOREMOVE
else
  echo "NOTHING DONE! -- try --clean=yes"
fi
