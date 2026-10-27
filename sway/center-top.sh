#!/bin/bash

# centers a floating window horizontally at the top of its workspace
#
# usage: center-top.sh <app_id>

APP_ID="$1"

read -r CON_ID WIDTH WS_WIDTH <<< "$(
  swaymsg -t get_tree -r \
    | jq -r --arg app "$APP_ID" \
      '..|select(.type?=="workspace") as $ws
        |$ws.floating_nodes[]
        |select(.app_id==$app)
        |"\(.id) \(.rect.width) \($ws.rect.width)"' \
    | head -1
)"

if [ -z "$CON_ID" ]; then
  exit 1
fi

swaymsg -q "[con_id=$CON_ID] move position $(((WS_WIDTH - WIDTH) / 2)) 0"
