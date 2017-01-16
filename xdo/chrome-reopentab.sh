#!/bin/bash

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))
DELAY=0

#echo ">> $0 $KEY $WWID $WPID $PROC / $ACTUAL_KEY" >> /tmp/xdo.log
if [[ "$PROC" == "chrome" || "$PROC" == "chromium-browse" ]]; then
  xdotool key --clearmodifiers --delay $DELAY Ctrl+Shift+t
else
  xdotool key --clearmodifiers --delay $DELAY Ctrl+Shift+b
fi
