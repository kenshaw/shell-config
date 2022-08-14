#!/bin/bash

CHROME_DIR="/home/$USER/.config/google-chrome-vpn"

rm -rf "$CHROME_DIR"
google-chrome \
  --user-data-dir="$CHROME_DIR" \
  --proxy-server="socks5://localhost:8080" \
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
  --window-position=10,32 'http://ifconfig.me/all'
