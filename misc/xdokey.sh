#!/bin/bash
KEY=$1
PROC=$(cat /proc/$(xdotool getwindowpid $(xdotool getwindowfocus))/comm)

if [[ "$PROC" == "/usr/bin/termin" ]]; then
  KEY=$(echo $KEY|sed -e 's/Page_/Shift+Page_/')
fi

xdotool getactivewindow key --clearmodifiers "$KEY"
