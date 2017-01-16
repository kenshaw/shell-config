#!/bin/bash

KEY=$1
MOUSE_BTN=$(echo "$KEY" | sed -e 's/Down/5/' -e 's/Up/4/')
ACTUAL_KEY="$(echo "$KEY" | sed -e 's/Down/h/' -e 's/Up/t/')"

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))
DELAY=0

#echo ">> $0 $KEY $WWID $WPID $PROC / $MOUSE_BTN $ACTUAL_KEY" >> /tmp/xdo.log
case "$PROC" in
  termin)
    TITLE=$(xdotool getwindowname $WWID)
    if [[ $TITLE = *VIM* || $TITLE = WeeChat* ]]; then
      # if we're in a vim session, send Page_Up/Page_Down
      xdotool key --clearmodifiers --delay $DELAY "Page_$KEY"
    else
      # else do a mouse scroll (4x)
      xdotool click --clearmodifiers --delay $DELAY $MOUSE_BTN click --clearmodifiers --delay $DELAY $MOUSE_BTN click --clearmodifiers --delay $DELAY $MOUSE_BTN click --clearmodifiers --delay $DELAY $MOUSE_BTN
    fi
    ;;

  chrome | chromium-browse)
    # send chrome a mouse scroll (3x)
    xdotool key --clearmodifiers --delay $DELAY $KEY mousemove 1575 1075
    ;;

  *)
    xdotool key --clearmodifiers --delay $DELAY Ctrl+$ACTUAL_KEY
esac
