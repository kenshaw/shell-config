#!/bin/bash

swaymsg -t get_tree \
  | jq '.. | (.nodes? // empty)[] | select(.focused==true) | {name, pid, class, app_id}'
