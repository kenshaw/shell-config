#!/bin/bash

google-chrome \
  --user-data-dir="/home/$USER/.config/google-testing" \
  --enable-features=UseOzonePlatform \
  --ozone-platform=wayland \
  --ignore-gpu-blocklist \
  --enable-gpu-rasterization \
  --enable-zero-copy \
  --disable-gpu-driver-bug-workarounds \
  --enable-accelerated-video-decode \
  --enable-features=VaapiVideoDecoder \
  --allow-file-access-from-files \
  --disable-web-security
