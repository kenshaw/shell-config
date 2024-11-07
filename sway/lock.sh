#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mpvctl=$HOME/.local/lib/mpvpaper/control

swayidle \
  -w \
  timeout 10 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"' \
  timeout 10 "socat - $mpvctl <<< 'set pause yes'" \
  resume "socat - $mpvctl <<< 'set pause no'" &

#swaylock-plugin \
#  --command "mpvpaper -o 'no-audio --loop-playlist shuffle --speed=0.8 --osd-margin-y=70 --osd-playing-msg-duration=7500 --osd-playing-msg=\"\${osd-ass-cc/0}{\\\\\\\\an2}\${osd-ass-cc/1}\${media-title}\"' '*' ~/Pictures/backgrounds/apple/wallpapers.m3u"

swaylock \
  --color 000000 \
  --image ~/Pictures/backgrounds/mountain-road-cropped.png

#$SRC/reorder.sh

kill %%
