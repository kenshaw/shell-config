#!/bin/bash

DATE=$(date +%Y-%m-%d_%H:%M:%S)
OUT=$HOME/Pictures/recordings
AUDIO=

OPTIND=1
while getopts "a:t:o:e:" opt; do
case "$opt" in
  a) AUDIO=$OPTARG ;;
  t) DATE=$OPTARG ;;
  o) OUT=$OPTARG ;;
  e) EXPIRATION=$OPTARG ;;
esac
done

set -e

mkdir -p $OUT

TMP=/tmp/rr-$DATE.mp4
FINAL=$OUT/rr-$DATE.mp4

PARAMS=(
  -c libx264
  -C aac
  -f $TMP
)

if [[ "$AUDIO" != "" ]]; then
  PARAMS+=(--audio="$AUDIO")
fi

wf-recorder -g "$(slurp)" ${PARAMS[@]}

mv $TMP $FINAL
