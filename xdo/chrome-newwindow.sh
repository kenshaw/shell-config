#!/bin/bash

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))

#echo ">> $0 $KEY $WWID $WPID $PROC / $ACTUAL_KEY" >> /tmp/xdo.log
if [[ "$PROC" == "chrome" || "$PROC" == "chromium-browse" ]]; then
  #xdotool key --clearmodifiers Ctrl+n
  PEXEC=google-chrome
  if [[ "$PROC" == "chromium-browse" ]]; then
    PEXEC=chromium-browser
  fi
  $PEXEC --new-window
  $HOME/src/shell-config/xdo/chrome-reorder.sh
  #xdotool key --clearmodifiers ''
else
  xdotool key --clearmodifiers Ctrl+m
fi
