#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LIBRARY="$HOME/Calibre Library"
OUT=$HOME/epub

FILES=$(find "$LIBRARY" -type f \( -iname \*.pdf -o -iname \*epub \) |grep -v 'original_epub')

(set -x;
  mkdir -p $OUT
)

while IFS= read -r line; do
  dir=$(cut -d/ -f6 <<< "$line")
  num=$(sed -e 's/.*(\([0-9]\+\))$/\1/' <<< "$dir")
  name=$(echo "$dir"|rev|cut -d' ' -f2-|rev|tr -c -d '[a-zA-Z0-9 ]'|cut -c1-64|xargs)
  ext="${line##*.}"
  (set -x;
    cp -a "$line" "$OUT/$(printf "%03d" "$num") ${name}.${ext}"
  )
done <<< "$FILES"
