#!/bin/bash

CLEAR=0
BROWSER=google-chrome-unstable
PROFILE=p
TOR=0

OPTIND=1
while getopts "b:dp:t" opt; do
case "$opt" in
  d) CLEAR=1 ;;
  b) BROWSER=$OPTARG ;;
  p) PROFILE=$OPTARG ;;
  t) TOR=1 ;;
esac
done

case "$PROFILE" in
  c)     TOR=1 ;;
  onion) TOR=1 CLEAR=1 ;;
esac

PROFILE_DIR=$HOME/.config/$BROWSER-$PROFILE
CACHE_DIR=$HOME/.cache/$BROWSER-$PROFILE

ARGS=(
  --user-data-dir="$PROFILE_DIR"
  --disk-cache-dir="$CACHE_DIR"
  --no-default-browser-check
  --no-first-run
  --restore-last-session
  --enable-webrtc-pipewire-capturer
)

if [ "$TOR" -eq "1" ]; then
  ARGS+=(--proxy-server="socks5://127.0.0.1:9050")
fi

if [ "$CLEAR" -eq "1" ]; then
  (set -x;
    rm -rf "$PROFILE_DIR" "$CACHE_DIR"
  )
fi

(set -x;
  $BROWSER ${ARGS[@]}
)
