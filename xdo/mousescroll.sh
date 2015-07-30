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
    if [[ $TITLE = *VIM* || $TITLE = WeeChat* ]]; then
      # if we're in a vim session, send Page_Up/Page_Down
      xdotool key --clearmodifiers "Page_$KEY"
    else
      # else do a mouse scroll (4x)
      xdotool click --clearmodifiers $MOUSE_BTN click --clearmodifiers $MOUSE_BTN click --clearmodifiers $MOUSE_BTN click --clearmodifiers $MOUSE_BTN
    fi
    ;;

  chrome | chromium-browse)
    # send chrome a mouse scroll (3x)
    xdotool key --clearmodifiers $KEY mousemove 1575 1075 key --clearmodifiers ''
    ;;

  *)
    xdotool key --clearmodifiers Ctrl+$ACTUAL_KEY key --clearmodifiers ''
esac
