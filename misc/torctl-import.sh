#!/bin/bash

FILES=$1

if [ -z "$FILES" ]; then
  echo "usage: $0 <files.txt>"
  exit 1
fi

while read LINE; do
  f=($LINE.*.torrent)
  echo "--- $LINE"
  if [ -f "${f[0]}" ]; then
    echo ">>> $LINE"
    (set -x; torctl add --timeout 60s --rm "${f[0]}")
  fi
done < $FILES
