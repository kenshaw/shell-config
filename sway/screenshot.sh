#!/bin/bash

CROP=0
DATE=$(date +%Y-%m-%d_%H:%M:%S)
OUT=$HOME/Pictures/screenshots

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
CROPPED=$OUT/original/ss-$DATE.cropped.png
COORDSOUT=$OUT/original/ss-$DATE.cropped.txt
FINAL=$OUT/ss-$DATE.png

grim -c -l 0 $SS

if [[ "$CROP" == "1" ]]; then
  COORDS="$(slurp -f '%wx%h+%x+%y')"
  convert $SS -crop "$COORDS" $CROPPED
  echo $COORDS|tee $COORDSOUT
fi

pngquant -o $SS.quantized $SS
mv $SS.quantized $SS

if [ ! -z "$CROP" ]; then
  pngquant -o $CROPPED.quantized $CROPPED
  mv $CROPPED.quantized $CROPPED
  cp $CROPPED $FINAL
else
  cp $SS $FINAL
fi
