#!/bin/bash

KEY=$1
MOUSE_BTN=$(echo "$KEY" | sed -e 's/Down/5/' -e 's/Up/4/')
ACTUAL_KEY="$(echo "$KEY" | sed -e 's/Down/h/' -e 's/Up/t/')"

WWID=$(xdotool getactivewindow)
WPID=$(xdotool getwindowpid $WWID)
PROC=$(basename $(cat /proc/$WPID/comm))

#echo ">> $0 $KEY $WWID $WPID $PROC / $MOUSE_BTN $ACTUAL_KEY" >> /tmp/xdo.log
case "$PROC" in
  termin)
    TITLE=$(xdotool getwindowname $WWID)
    if [[ $TITLE = *VIM* ]]; then
      # if we're in a vim session, send Page_Up/Page_Down
      xdotool key --clearmodifiers --window $WWID "Page_$KEY"
    else
      # else do a mouse scroll (4x)
      xdotool click --clearmodifiers --window $WWID $MOUSE_BTN click --clearmodifiers --window $WWID $MOUSE_BTN click --clearmodifiers --window $WWID $MOUSE_BTN click --clearmodifiers --window $WWID $MOUSE_BTN
    fi
    ;;

  chrome)
    # send chrome a mouse scroll (3x)
    xdotool key --clearmodifiers --window $WWID $KEY
    ;;

  *)
    xdotool key --clearmodifiers $WWID Ctrl+$ACTUAL_KEY
esac
