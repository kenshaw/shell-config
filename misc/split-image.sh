#!/bin/bash

IMG=$1
if [ -z "$IMG" ]; then
  echo "usage: $0 <IMAGE>"
  exit 1
fi
IMG=$(realpath "$IMG")

DIR=$(dirname "$IMG")
BASE=$(basename "$IMG")

LEFT="${DIR}/${BASE%%.*}-left.${BASE#*.}"
RIGHT="${DIR}/${BASE%%.*}-right.${BASE#*.}"

(set -x;
  rm -f "$LEFT" "$RIGHT"
  cp "$IMG" "$LEFT"
  cp "$IMG" "$RIGHT"
  mogrify -crop 3840x2160+0+0 "$LEFT"
  mogrify -crop 3840x2160+3840+0 "$RIGHT"
)
