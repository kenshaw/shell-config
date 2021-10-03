#!/bin/bash

CHROME_DIR="/home/$USER/.config/google-chrome-onion"

rm -rf "$CHROME_DIR"
google-chrome-unstable \
  --user-data-dir="$CHROME_DIR" \
  --proxy-server="socks5://localhost:9050" \
  --no-first-run \
  --window-size=1500,1060 \
  --remote-debugging-port=9222 \
  --window-position=10,32 'http://facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhb
