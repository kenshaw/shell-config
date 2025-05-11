#!/bin/bash

SIZEX=3000 SIZEY=1800
STARTX=10 STARTY=10 INCX=90 INCY=80

BROWSERS=(
  firefox
  google-chrome
  google-chrome-unstable
  thorium-browser
  vivaldi-stable
)

BROWSERLIST='"'$(sed -e 's/ /","/g' <<< "${BROWSERS[@]}")'"'
TREE=$(swaymsg -t get_tree -r)

if [ "$1" = "--init" ]; then
  ALL=$(
    jq -r \
      "getpath(path(..|select(.type?))|.[0:4]).floating_nodes[]
        |select(.app_id,.window_properties.instance|IN($BROWSERLIST))
        |[.id]
        |@sh" \
      <<< "$TREE" \
      | sort -n -k 2 \
      | uniq
  )
  COMMANDS=""
  while IFS= read -r line; do
    con_id=$(awk '{print $1}' <<< "$line")
    COMMANDS+="[con_id=$con_id] move container to workspace 1; "
  done <<< "$ALL"
  (set -x;
    swaymsg "$COMMANDS"
  )
fi

ACTIVE=$(
  jq -r \
    "..|select(.type?)|select(.focused==true)|.id" \
    <<< "$TREE"
)

WINDOWS=$(
  jq -r \
    "getpath(path(..|select(.type?)|select(.focused==true).pid)|.[0:4]).floating_nodes[]
      |select(.app_id,.window_properties.instance|IN($BROWSERLIST))
      |[.id, .rect.x]
      |@sh" \
    <<< "$TREE" \
  | sort -n -k 2 \
  | sed -e "/^$ACTIVE\s/ { h; \$p; d; }" -e '$G'
)

COMMANDS=""

# cascade tile all browser windows
if [ ! -z "$WINDOWS" ]; then
  x=$STARTX y=$STARTY
  if [ "$(wc -l <<< "$WINDOWS")" = "1" ]; then
    x=$((x + INCX)) y=$((y + INCY))
  fi
  while IFS= read -r line; do
    con_id=$(awk '{print $1}' <<< "$line")
    COMMANDS+="[con_id=$con_id] resize set $SIZEX $SIZEY, move container to position $x $y, focus; "
    x=$((x + INCX)) y=$((y + INCY))
  done <<< "$WINDOWS"
fi
# refocus active window
COMMANDS+="[con_id=$ACTIVE] focus; "

# move calculator
COMMANDS+='[app_id="^org\.gnome\.Calculator$"] floating enable, resize set 680 860, move position 3000 200; '

# move plexamp
COMMANDS+='[app_id="(?i)^plexamp$" workspace="^[14]$"] floating enable, resize set 540 1000, move position 3285 1095; '
COMMANDS+='[app_id="(?i)^plexamp$" workspace="^[23]$"] floating enable, resize set 540 1000, move position 3285 950; '
COMMANDS+='[instance="(?i)^plexamp$" workspace="^[14]$"] floating enable, resize set 540 1000, move position 3285 1095; '
COMMANDS+='[instance="(?i)^plexamp$" workspace="^[23]$"] floating enable, resize set 540 1000, move position 3285 950; '

# move windows vms
COMMANDS+='[app_id="(?i)^qemu-system-x86_64$"] floating enable, resize set 2240 1792, move position 1550 50, move workspace 2; '

(set -x;
  swaymsg "$COMMANDS"
)
