#!/bin/bash

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))

#echo ">> $0 $KEY $WWID $WPID $PROC / $ACTUAL_KEY" >> /tmp/xdo.log
if [[ "$PROC" == "chrome" || "$PROC" == "chromium-browse" ]]; then
  xdotool key --clearmodifiers --delay 0 Ctrl+Shift+t
else
  xdotool key --clearmodifiers --delay 0 Ctrl+Shift+b
fi
