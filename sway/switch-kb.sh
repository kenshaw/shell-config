#!/bin/bash

LAYOUT=${1:-dvorak}

INPUTS=$(swaymsg -t get_inputs --raw|jq -r '.[].identifier')
for kb in $INPUTS; do
  (set -x;
    swaymsg input "$kb" xkb_switch_layout next
  )
done
