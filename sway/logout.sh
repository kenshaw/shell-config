#!/bin/bash

killall -9 swaynag

swaynag -t warning \
  -m 'Exit?' \
  -e bottom \
  -z ' 󰗼 ' 'swaymsg exit' \
  -z '  ' 'systemctl -i reboot' \
  -z ' ⏻ ' 'systemctl -i poweroff' \
  -z ' 󰍁 ' "$HOME/src/shell-config/sway/lock.sh" \
  -s ' 󰖭 '
