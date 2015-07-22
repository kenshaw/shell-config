#!/bin/bash

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))

#echo ">> $0 $KEY $WWID $WPID $PROC / $ACTUAL_KEY" >> /tmp/xdo.log
if [[ "$PROC" == "chrome" ]]; then
  xdotool key --clearmodifiers Ctrl+t key --clearmodifiers ''
else
  xdotool key --clearmodifiers Ctrl+b key --clearmodifiers ''
fi
