#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -e

mpvctl=$HOME/.local/lib/mpvpaper/control
mpvlck=$HOME/.local/lib/mpvpaper/lock

params=(
  --no-audio
  --hwdec
  --input-ipc-server=$mpvlck
  --loop-playlist
  --shuffle
  --speed=0.8
  --osd-margin-y=70
  --osd-playing-msg-duration=7500
  --osd-playing-msg='${osd-ass-cc/0}{\\an2}${osd-ass-cc/1}${media-title}'
)

(set -x;
  swayidle \
    -w \
    timeout 30 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    timeout 30 "socat - $mpvctl <<< 'set pause yes'" \
    resume "socat - $mpvctl <<< 'set pause no'" \
    timeout 30 "socat - $mpvlck <<< 'set pause yes'" \
    resume "socat - $mpvlck <<< 'set pause no'" &

  swaylock-plugin \
    --command "mpvpaper -o '$(printf '%s\n' "${params[@]}"|paste -sd' ')' '*' ~/Pictures/backgrounds/aerials/aerials.m3u"

  kill %%
)

#swaylock \
#  --color 000000 \
#  --image ~/Pictures/backgrounds/mountain-road-cropped.png

#$SRC/reorder.sh
