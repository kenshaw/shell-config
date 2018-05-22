#!/bin/bash

KERNEL=$(uname -r | sed -e 's/-\(generic\|amd64\)$//')
REMOVE=$(dpkg --get-selections |egrep '^linux-.*-[0-9]\.[0-9]+\.[0-9]+-[0-9]+' | sed -e 's/\s*\(install\|deinstall\|purge\)$//' | grep -v $KERNEL| tr "\\n" " ")

set -e

echo "KERNEL: $KERNEL"
echo "REMOVE: $REMOVE"

if [ "$USER" != "root" ]; then
  echo "not root!"
  exit
fi

if [ "$1" == "--clean=yes" ]; then
  aptitude purge $TOREMOVE
else
  echo "NOTHING DONE! -- try --clean=yes"
fi
