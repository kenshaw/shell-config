#!/bin/bash

LIBRARY="$HOME/Calibre Library"
OUT=$HOME/epub

FILES=$(
  find "$LIBRARY" \
    -type f \
    -not -path "*caltrash*" \
    -and -not -path "*calnotes" \
    -and -not -path "*original_epub*" \
    -and \(  \
      -iname \*.pdf \
      -or -iname \*epub \
    \)
)

(set -x;
  mkdir -p $OUT
)

while IFS= read -r line; do
  dir=$(cut -d/ -f6 <<< "$line")
  num=$(sed -e 's/.*(\([0-9]\+\))$/\1/' <<< "$dir")
  name=$(echo "$dir"|rev|cut -d' ' -f2-|rev|tr -c -d '[a-zA-Z0-9 ]'|cut -c1-64|xargs)
  ext="${line##*.}"
  num=$(printf "%03d" "$num")
  (set -x;
    cp -a "$line" "$OUT/$num ${name}.${ext}"
  )
done <<< "$FILES"
