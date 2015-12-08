#!/bin/bash

KEY=$1
MOUSE_BTN=$(echo "$KEY" | sed -e 's/Down/5/' -e 's/Up/4/')
ACTUAL_KEY="$(echo "$KEY" | sed -e 's/Up/d/' -e 's/Down/n/')"

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))

#echo ">> $0 $KEY $WWID $WPID $PROC / $ACTUAL_KEY" >> /tmp/xdo.log
case "$PROC" in
  termin)
    xdotool key --clearmodifiers --delay 0 Ctrl+Shift+Page_$KEY
    ;;

  chrome | chromium-browse)
    xdotool key --clearmodifiers --delay 0 Ctrl+Shift+Page_$KEY
    ;;

  *)
    xdotool key --clearmodifiers --delay 0 Ctrl+Shift+Page_$KEY
esac
