#!/bin/bash

IMG=$1
if [ -z "$IMG" ]; then
  echo "usage: $0 <IMAGE>"
  exit 1
fi
IMG=$(realpath "$IMG")

DIR=$(dirname "$IMG")
BASE=$(basename "$IMG")

IMG0="${DIR}/${BASE%%.*}-0.${BASE#*.}"
IMG1="${DIR}/${BASE%%.*}-1.${BASE#*.}"

(set -x;
  rm -f "$IMG0" "$IMG1"
  cp "$IMG" "$IMG0"
  cp "$IMG" "$IMG1"
  mogrify -crop 3840x2160+0+0 "$IMG0"
  mogrify -crop 3840x2160+3840+0 "$IMG1"
)
