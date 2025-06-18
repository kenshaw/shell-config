#!/bin/bash

LAYOUT=$(swaymsg -t get_inputs \
  |jq -r '[.[]|select(.type=="keyboard")|select(.name|contains("Keyboard"))][0].xkb_active_layout_name' \
  |cut -d '(' -f2 \
  |cut -d ')' -f1 \
  |tr '[A-Z]' '[a-z]')

echo "${LAYOUT:0:2}"
