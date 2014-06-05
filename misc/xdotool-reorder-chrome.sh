#!/bin/bash

WINDOWS=$(xdotool search --onlyvisible --class "chrome"|sort)

if [ -z "$WINDOWS" ]; then
  exit 0
fi

FWIN=$(echo $WINDOWS|cut -d" " -f1)

POSX=10
for i in $WINDOWS; do
  xdotool windowmove $i $POSX 35
  POSX=$((POSX = POSX + 35))
done
