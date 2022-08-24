#!/bin/bash

PID=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.type=="con") | select(.focused==true).pid')
readlink /proc/$(pgrep --newest --parent $PID)/cwd || echo $HOME
