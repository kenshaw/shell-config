#!/bin/bash

SIZEX=3000 SIZEY=1800
STARTX=10 STARTY=10 INCX=30 INCY=30

BROWSERS=(
  firefox
  google-chrome
  google-chrome-unstable
  thorium-browser
  vivaldi-stable
)

BROWSERLIST='"'$(sed -e 's/ /","/g' <<< "${BROWSERS[@]}")'"'

TREE=$(swaymsg -t get_tree -r)

#OFFSET=$(
#  jq -r \
#    'getpath(path(..|select(.type?)|select(.focused==true).pid)|.[0:4]).rect|[.x, .y]|@sh' \
#    <<< "$TREE"
#)

WINDOWS=$(
  jq -r \
    "getpath(path(..|select(.type?)|select(.focused==true).pid)|.[0:4]).floating_nodes[]
      |select(.app_id|IN($BROWSERLIST))
      |[.id, .rect.x]
      |@sh" \
    <<< "$TREE" \
  | sort -n -k 2
)

if [ ! -z "$WINDOWS" ]; then
# cascade tile all browser windows
  x=$STARTX y=$STARTY
  while IFS= read -r line; do
    con_id=$(awk '{print $1}' <<< "$line")
    swaymsg "[con_id=$con_id] resize set $SIZEX $SIZEY, move container to position $x $y, focus"
    x=$((x + INCX)) y=$((y + INCY))
  done <<< "$WINDOWS"
fi

# fix calculator
swaymsg '[app_id="^org\.gnome\.Calculator$"] floating enable, resize set 680 860, move position 3000 200'

# fix plexamp
swaymsg '[class="(?i)^plexamp$"] floating enable, resize set 540 1000, move workspace 1, move position 3285 1095'
