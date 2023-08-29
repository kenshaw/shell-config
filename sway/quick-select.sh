#!/bin/bash

set -e

PROFILE=$(wofi \
  --cache-file $HOME/.cache/wofi-quick-select \
  --dmenu \
  --prompt "Quick Select Profile" \
<< _END_
p
x
c
_END_
)

(set -x;
firefox -P "$(xargs <<< "$PROFILE")"
)
