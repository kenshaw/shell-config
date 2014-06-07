#!/bin/bash

WINDOWS=$(xdotool search --onlyvisible --class "google-chrome")

POSX=10
POSY=45
SIZEX=1500
SIZEY=1060

if [ -z "$WINDOWS" ]; then
  exit 0
fi

for i in $WINDOWS; do
  NAME=$(xdotool getwindowname $i)
  if [[ ! "$NAME" =~ 'Google Play Music Mini Player' ]]; then
    xdotool windowsize $i $SIZEX $SIZEY windowmove $i $POSX $POSY
    POSX=$((POSX = POSX + 35))
  fi
done
