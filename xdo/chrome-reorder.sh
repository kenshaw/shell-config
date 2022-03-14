#!/bin/bash

RESY=$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $4}')

POSX=10
POSY=40
SIZEX=1500
SIZEY=1060
SPACING=25
DELAY=0

case $RESY in
  2160)
    POSX=20
    POSY=80
    SIZEX=3000
    SIZEY=2000
    SPACING=35
  ;;
esac

WINDOWS=$(xdotool search --all --onlyvisible --class '(chrome|chromium|vivaldi|brave)')
WACTIVE=$(xdotool getactivewindow)
if [ -z "$WINDOWS" ]; then
  exit 0
fi

# reorder windows based on their x positions, and exclude the active window
WLIST=""
for i in $WINDOWS; do
  WLIST+="$i $(xdotool getwindowgeometry --shell $i|grep '^X='|cut -d'=' -f2)\n"
done
WINDOWS=$(echo -e "$WLIST"|sort -n -k2|cut -d' ' -f1|egrep -v "^$WACTIVE$"|sed -e '/^\s*$/d')

# add active window to end of window list if chrome
WACTIVE_CLASS=$(xprop -id $WACTIVE | sed -n 's/^WM_CLASS(STRING) = "\([^"]\+\)".*/\1/p')
if [[ "$WACTIVE_CLASS" =~ (chrome|chromium|vivaldi|brave) ]]; then
  WINDOWS=$(echo -e "$WINDOWS\n$WACTIVE")
fi

# loop through windows
for i in $WINDOWS; do
  # ignore window if its fullscreen
  if [ -z "$(xprop -id $i|egrep '^_NET_WM_STATE\(ATOM\)\s*=\s*_NET_WM_STATE_(ABOVE|FULLSCREEN)$')" ]; then
    # resize the window, move it to the right position, raise it, and then focus
    xdotool windowactivate $i windowsize $i $SIZEX $SIZEY windowmove $i $POSX $POSY windowraise $i
    POSX=$((POSX + SPACING))
  fi
done

# move back to original window
xdotool windowraise $WACTIVE windowfocus --sync $WACTIVE
