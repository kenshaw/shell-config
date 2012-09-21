#!/bin/bash

KERNEL=`uname -r | sed -e 's/-generic$//'`

TOREMOVE=`dpkg --get-selections | grep 'install$'|egrep 'linux-(image|headers)' | sed -e 's/\s*install$//' | egrep -v '^linux-(image|headers)-generic$' | grep -v $KERNEL| tr "\\n" " "`

if [ "$USER" != "root" ]; then
  echo "not root!"
  exit
fi

echo "CURRENT: $KERNEL"
echo "REMOVING: $TOREMOVE"

if [ "$1" == "--clean=yes" ]; then
  aptitude purge $TOREMOVE
else
  echo "NOTHING DONE! -- try --clean=yes"
fi
