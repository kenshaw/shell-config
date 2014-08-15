#!/bin/bash

KERNEL=`uname -r | sed -e 's/-generic$//'`
GKERNEL=``

TOREMOVE=`dpkg --get-selections | grep 'install$'|egrep 'linux-(image|headers)' | sed -e 's/\s*\(de\)\?install$//' | egrep -v '^linux-(image|headers)-generic$' | grep -v $KERNEL| tr "\\n" " "`

echo "CURRENT: $KERNEL"
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
