#!/bin/bash

PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]'|sed -e 's/^\(msys\|mingw\).*/windows/')

# downloads fonts

FONTS=(
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/InconsolataNerdFont-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/InconsolataNerdFontMono-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/InconsolataLGCNerdFontMono-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/InconsolataLGCNerdFont-Regular.ttf"
  "https://github.com/xo/usql-logo/raw/master/NotoMono-Regular.ttf"
)

if [[ "$XDG_SESSION_TYPE" != "x11" && "$XDG_SESSION_TYPE" != "wayland" && "$PLATORM" != "darwin" ]]; then
  echo "error: not on x11/wayland/darwin "
  exit 1
fi

grab() {
  echo -n "RETRIEVING: $1 -> $2     "
  wget -4 --progress=dot -O "$2" "$1" 2>&1 |\
    grep --line-buffered "%" | \
    sed -u -e "s,\.,,g" | \
    awk '{printf("\b\b\b\b%4s", $2)}'
  echo -ne "\b\b\b\b"
  echo " DONE."
}

DEST=$HOME/.fonts

case $PLATFORM in
  darwin) DEST=$HOME/Library/Fonts ;;
esac

mkdir -p $DEST

for FONT in "${FONTS[@]}"; do
  FILE=$DEST/$(basename "$FONT")
  if [ ! -e "$FILE" ]; then
    grab "$FONT" "$FILE"
  fi
done

case $PLATFORM in
  linux) fc-cache ;;
esac
