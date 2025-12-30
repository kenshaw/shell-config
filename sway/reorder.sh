#!/bin/bash

BROWSER_X=10 BROWSER_Y=10
BROWSER_W=3000 BROWSER_H=1800 BROWSER_INCX=90 BROWSER_INCY=80

SHELL_X=460 SHELL_Y=680
SHELL_W=2900 SHELL_H=1150 SHELL_INCX=130 SHELL_INCY=60

BROWSERS=(
  firefox
  google-chrome
  google-chrome-unstable
  thorium-browser
  vivaldi-stable
)

SHELLS=(
  com.mitchellh.ghostty
)

BROWSERLIST='"'$(sed -e 's/ /","/g' <<< "${BROWSERS[@]}")'"'
SHELLLIST='"'$(sed -e 's/ /","/g' <<< "${SHELLS[@]}")'"'

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

COMMANDS=""

# get all floating browser windows
BROWSER_WINDOWS=$(
  jq -r \
    "getpath(path(..|select(.type?)|select(.focused==true).pid)|.[0:4]).floating_nodes[]
      |select(.app_id,.window_properties.instance|IN($BROWSERLIST))
      |[.id, .rect.x]
      |@sh" \
    <<< "$TREE" \
  | sort -n -k 2 \
  | sed -e "/^$ACTIVE\s/ { h; \$p; d; }" -e '$G'
)

# cascade tile all browser windows
if [ ! -z "$BROWSER_WINDOWS" ]; then
  x=$BROWSER_X y=$BROWSER_Y
  if [ "$(wc -l <<< "$BROWSER_WINDOWS")" = "1" ]; then
    x=$((x + BROWSER_INCX)) y=$((y + BROWSER_INCY))
  fi
  while IFS= read -r line; do
    con_id=$(awk '{print $1}' <<< "$line")
    COMMANDS+="[con_id=$con_id] resize set $BROWSER_W $BROWSER_H, move container to position $x $y, focus; "
    x=$((x + BROWSER_INCX)) y=$((y + BROWSER_INCY))
  done <<< "$BROWSER_WINDOWS"
fi

# get all floating shell windows
SHELL_WINDOWS=$(
  jq -r \
    "getpath(path(..|select(.type?)|select(.focused==true).pid)|.[0:4]).floating_nodes[]
      |select(.app_id,.window_properties.instance|IN($SHELLLIST))
      |[.id, .rect.x]
      |@sh" \
    <<< "$TREE" \
  | sort -n -k 2 \
  | sed -e "/^$ACTIVE\s/ { h; \$p; d; }" -e '$G'
)

# cascade tile all shell windows
if [ ! -z "$SHELL_WINDOWS" ]; then
  x=$SHELL_X y=$SHELL_Y
  while IFS= read -r line; do
    con_id=$(awk '{print $1}' <<< "$line")
    COMMANDS+="[con_id=$con_id] resize set $SHELL_W $SHELL_H, move container to position $x $y, focus; "
    x=$((x + SHELL_INCX)) y=$((y + SHELL_INCY))
  done <<< "$SHELL_WINDOWS"
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
