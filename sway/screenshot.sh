#!/bin/bash

ANNOTATE=0
CROP=0
DATE=$(date +%Y-%m-%d_%H:%M:%S)
OUT=$HOME/Pictures/screenshots
UPLOAD=0
EXPIRATION=$((7*24*3600))

OPTIND=1
while getopts "agt:o:ue:" opt; do
case "$opt" in
  a) ANNOTATE=1 ;;
  g) CROP=1 ;;
  t) DATE=$OPTARG ;;
  o) OUT=$OPTARG ;;
  u) UPLOAD=1 ;;
  e) EXPIRATION=$OPTARG ;;
esac
done

quantize() {
  pngquant -o $1.quantized $1
  mv $1.quantized $1
}

set -e

mkdir -p $OUT/original
mkdir -p $HOME/.config/ss

if [ ! -e $HOME/.config/ss/ibb ]; then
  echo "error: $HOME/.config/ss/ibb is missing!"
  exit 1
fi

APIKEY=$(cat $HOME/.config/ss/ibb)

SS=$OUT/original/ss-$DATE.png
CROPPED=$OUT/original/ss-$DATE.cropped.png
COORDSOUT=$OUT/original/ss-$DATE.cropped.txt
ANNOTATED=$OUT/original/ss-$DATE.annotated.png
FINAL=$OUT/ss-$DATE.png

grim -c -l 0 $SS

if [[ "$CROP" == "1" ]]; then
  COORDS="$(slurp -f '%wx%h+%x+%y')"
  convert $SS -crop "$COORDS" $CROPPED
  echo "$COORDS" | tee -a $COORDSOUT &> /dev/null
fi

WORKING=$SS
if [[ "$CROP" == "1" ]]; then
  WORKING=$CROPPED
fi
if [[ "$ANNOTATE" == "1" ]]; then
  cp $WORKING $ANNOTATED
  satty --filename $ANNOTATED --output-filename $ANNOTATED
  WORKING=$ANNOTATED
fi

cp $WORKING $FINAL
quantize $FINAL

# upload to ibb
if [[ "$UPLOAD" == "1" ]]; then
  RES=$(
    curl \
      --silent \
      --location \
      --request POST \
      --form image=@$FINAL \
      "https://api.imgbb.com/1/upload?expiration=$EXPIRATION&key=$APIKEY"
  )
  #cat <<< "$RES"
  URL=$(jq -r .data.image.url <<< "$RES")
  xdg-open "$URL"
  wl-copy <<< "$URL"
fi

quantize $SS
if [[ "$CROP" == "1" ]]; then
  quantize $CROPPED
fi
if [[ "$ANNOTATE" == "1" ]]; then
  quantize $ANNOTATED
fi
