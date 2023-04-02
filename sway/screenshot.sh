#!/bin/bash

OUT=$HOME/Pictures/screenshots
DATE=$(date +%Y-%m-%d_%H:%M:%S)
CROP=

OPTIND=1
while getopts "gt:o:" opt; do
case "$opt" in
  g) CROP=1 ;;
  t) DATE=$OPTARG ;;
  o) OUT=$OPTARG ;;
esac
done

set -e

mkdir -p $OUT/original

SS=$OUT/original/ss-$DATE.png
FINAL=$OUT/ss-$DATE.png

grim -c -l 0 $SS

if [ ! -z "$CROP" ]; then
  convert $SS -crop "$(slurp -f '%wx%h+%x+%y')" $SS.cropped
fi

pngquant -o $SS.quantized $SS
mv $SS.quantized $SS

if [ ! -z "$CROP" ]; then
  pngquant -o $SS.cropped.quantized $SS.cropped
  mv $SS.cropped.quantized $SS.cropped
  cp $SS.cropped $FINAL
else
  cp $SS $FINAL
fi
