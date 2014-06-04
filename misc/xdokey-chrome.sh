#!/bin/bash

KEY=$1
PROC=$(cat /proc/$(xdotool getactivewindow getwindowpid)/comm)

if [[ "$PROC" == "chrome" ]]; then
  KEY=$(echo $KEY|sed -e 's/Page_/Ctrl+Page_/')
  xdotool getactivewindow key --clearmodifiers "$KEY"
fi
