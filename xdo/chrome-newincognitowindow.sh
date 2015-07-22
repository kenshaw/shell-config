#!/bin/bash

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))

#echo ">> $0 $KEY $WWID $WPID $PROC / $ACTUAL_KEY" >> /tmp/xdo.log
if [[ "$PROC" == "chrome" ]]; then
  #xdotool key --clearmodifiers Ctrl+Shift+n
  google-chrome --new-window --incognito
  $HOME/src/shell-config/xdo/chrome-reorder.sh
  xdotool key --clearmodifiers ''
else
  xdotool key --clearmodifiers Ctrl+Shift+m key --clearmodifiers ''
fi
