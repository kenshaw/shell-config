#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

swayidle \
  timeout 10 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"' &

swaylock \
  --color 000000 \
  --image ~/Pictures/backgrounds/mountain-road-cropped.png

$SRC/reorder.sh

kill %%
