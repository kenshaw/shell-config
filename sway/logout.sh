#!/bin/bash

swaynag -t warning \
  -m 'Exit?' \
  -z '' 'swaymsg exit' \
  -z '' 'systemctl -i reboot' \
  -z '⏻' 'systemctl -i poweroff' \
  -z '' "$HOME/src/shell-config/sway/lock.sh"
