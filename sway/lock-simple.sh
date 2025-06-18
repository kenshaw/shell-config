#!/bin/bash

set -e

(set -x;
  swayidle \
    -w \
    timeout 30 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &

  swaylock -c 000000

  kill %%
)
