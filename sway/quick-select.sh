#!/bin/bash

set -e

PROFILE=$(wofi \
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
