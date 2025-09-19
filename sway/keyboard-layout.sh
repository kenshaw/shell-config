#!/bin/bash

LAYOUT=$(
  swaymsg -t get_inputs \
    |jq -r '.[]|try select(.xkb_layout_names[]| try contains("English (Dvorak)"))|.xkb_active_layout_name' \
    |head -1 \
    |cut -d '(' -f2 \
    |cut -d ')' -f1 \
    |tr '[A-Z]' '[a-z]'
)

echo "${LAYOUT:0:2}"
