#!/bin/bash

WINDOWS=$(xdotool search --onlyvisible --class "google-chrome")

POSX=10
POSY=45
SIZEX=1500
SIZEY=1060
WDIST=35

WPLAYX=1605
WPLAYY=765

WACTIVE=$(xdotool getactivewindow)

if [ -z "$WINDOWS" ]; then
  exit 0
fi

# reorder windows based on their x positions, and exclude the last one
WLIST="$()"
for i in $WINDOWS; do
  eval $(xdotool getwindowgeometry --shell $i)
  WLIST+="$i $X\n"
done
WINDOWS=$(echo -e "$WLIST"|sort -n -k2|cut -d' ' -f1|egrep -v "^$WACTIVE$"|sed -e '/^\s*$/d')

# add active window to end of window list if chrome
WACTIVE_CLASS=$(xprop -id $WACTIVE | sed -n 's/^WM_CLASS(STRING) = "\([^"]\+\)".*/\1/p' )
if [[ "$WACTIVE_CLASS" =~ "chrome" ]]; then
  WINDOWS=$(echo -e "$WINDOWS\n$WACTIVE")
fi

# loop through windows
for i in $WINDOWS; do
  NAME=$(xdotool getwindowname $i)
  if [[ ! "$NAME" =~ 'Google Play Music Mini Player' ]]; then
    # resize the window, move it to the right position, raise it, and then focus
    xdotool windowsize $i $SIZEX $SIZEY windowmove $i $POSX $POSY windowraise $i windowfocus --sync $i
    POSX=$((POSX = POSX + WDIST))
  else
    xdotool windowmove $i $WPLAYX $WPLAYY
  fi
done

# move back to original window
xdotool windowraise $WACTIVE windowfocus --sync $WACTIVE
