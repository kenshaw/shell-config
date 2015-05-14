#!/bin/bash

CHROME_DIR="/home/$USER/.config/google-chrome-onion"

rm -rf "$CHROME_DIR"
google-chrome --user-data-dir="$CHROME_DIR" --proxy-server="socks://localhost:19050" --no-first-run --window-size=1500,1060 --window-position=10,32 'http://ifconfig.me/all'
