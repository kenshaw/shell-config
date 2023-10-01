#!/bin/bash

# downloads fonts

FONTS=(
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/InconsolataNerdFont-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/InconsolataNerdFontMono-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/Regular/InconsolataLGCNerdFontMono-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/Regular/InconsolataLGCNerdFont-Regular.ttf"
)

if [[ "$XDG_SESSION_TYPE" != "x11" && "$XDG_SESSION_TYPE" != "wayland" ]]; then
  echo "error: not on x11!"
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

mkdir -p $HOME/.fonts

for FONT in "${FONTS[@]}"; do
  FILE=$HOME/.fonts/$(basename "$FONT")
  if [ ! -e "$FILE" ]; then
    grab "$FONT" "$FILE"
  fi
done

fc-cache
