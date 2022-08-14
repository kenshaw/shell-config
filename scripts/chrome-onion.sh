#!/bin/bash

CHROME_DIR="/home/$USER/.config/google-chrome-onion"

rm -rf "$CHROME_DIR"
google-chrome-unstable \
  --user-data-dir="$CHROME_DIR" \
  --proxy-server="socks5://localhost:9050" \
  --enable-features=UseOzonePlatform \
  --ozone-platform=wayland \
  --ignore-gpu-blocklist \
  --enable-gpu-rasterization \
  --enable-zero-copy \
  --disable-gpu-driver-bug-workarounds \
  --enable-accelerated-video-decode \
  --enable-features=VaapiVideoDecoder \
  --no-first-run \
  --window-size=1500,1060 \
  --remote-debugging-port=9222 \
  --window-position=10,32 'https://ifconfig.me'
