#!/bin/bash

OUT=$1
EXT=png

if [ -z "$OUT" ]; then
  OUT=screen
fi

i=1
while [[ -e "$OUT-$(printf %02d $i).$EXT" ]]; do
  let i++
done

FILE=$OUT-$(printf %02d $i).$EXT

adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $FILE
