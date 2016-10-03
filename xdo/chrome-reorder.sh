#!/bin/bash

POSX=10
POSY=0
SIZEX=1500
SIZEY=1060
SPACING=25

WINDOWS="$(xdotool search --all --onlyvisible --class "google-chrome") $(xdotool search --all --onlyvisible --class "chromium-browser")"
WACTIVE=$(xdotool getactivewindow)

if [ -z "$WINDOWS" ]; then
  exit 0
fi

# reorder windows based on their x positions, and exclude the active window
WLIST=""
for i in $WINDOWS; do
  eval $(xdotool getwindowgeometry --shell $i)
  WLIST+="$i $X\n"
done
WINDOWS=$(echo -e "$WLIST"|sort -n -k2|cut -d' ' -f1|egrep -v "^$WACTIVE$"|sed -e '/^\s*$/d')

# add active window to end of window list if chrome
WACTIVE_CLASS=$(xprop -id $WACTIVE | sed -n 's/^WM_CLASS(STRING) = "\([^"]\+\)".*/\1/p')
if [[ "$WACTIVE_CLASS" =~ (chrome|chromium) ]]; then
  WINDOWS=$(echo -e "$WINDOWS\n$WACTIVE")
fi

# loop through windows
for i in $WINDOWS; do
  # ignore window if its fullscreen
  if [ -z "$(xprop -id $i|egrep '^_NET_WM_STATE\(ATOM\)\s*=\s*_NET_WM_STATE_(ABOVE|FULLSCREEN)$')" ]; then
    #NAME=$(xdotool getwindowname $i)
    # resize the window, move it to the right position, raise it, and then focus
    xdotool windowactivate $i windowsize $i $SIZEX $SIZEY windowmove $i $POSX $POSY windowraise $i
    POSX=$((POSX + SPACING))
  fi
done

# move back to original window
xdotool windowraise $WACTIVE windowfocus --sync $WACTIVE
