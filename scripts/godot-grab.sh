#!/bin/bash

CACHE_DIR=$HOME/.cache
GODOT_REPO=godotengine/godot
GODOT_VERSION=

CLEAN=0
DOWNLOAD=0
FORCE=

OPTIND=1
while getopts "cdfv:C:" opt; do
case "$opt" in
  c) CLEAN=1 ;;
  d) DOWNLOAD=1 ;;
  f) FORCE=1 ;;
  v) GODOT_VERSION=$OPTARG ;;
  C) CACHE_DIR=$OPTARG ;;
esac
done

github_release() {
  curl -s "https://api.github.com/repos/$1/releases/latest"|jq -r .tag_name
}

github_grab() {
  if [ "$FORCE" == "1" ]; then
    (set -x;
      rm -rf $3
    )
  fi
  DL="https://github.com/$1/releases/download/$2/$(basename "$3")"
  if [ ! -f "$3" ]; then
    curl -4 -L -# -o "$3" "$DL"
  fi
}

# godot version
if [ -z "$GODOT_VERSION" ]; then
  GODOT_VERSION=$(github_release "$GODOT_REPO")
fi

echo "VERSION: $GODOT_VERSION"
echo "CACHE:   $CACHE_DIR"

# godot binaries
mkdir -p $CACHE_DIR/godot
GODOT_ARCHIVE=$CACHE_DIR/godot/Godot_v${GODOT_VERSION}_linux.x86_64.zip
GODOT_TEMPLATES=$CACHE_DIR/godot/Godot_v${GODOT_VERSION}_export_templates.tpz

# grab
github_grab "$GODOT_REPO" "$GODOT_VERSION" "$GODOT_ARCHIVE"
github_grab "$GODOT_REPO" "$GODOT_VERSION" "$GODOT_TEMPLATES"

OUT=$(mktemp -d -p /tmp grab-godot.XXXXXX)

# extract godot
GODOT_DIR=$CACHE_DIR/godot/$GODOT_VERSION
GODOT_BIN=$HOME/.local/bin/godot
if [[ "$FORCE" == "1" || ! -d $GODOT_DIR || ! -x $GODOT_DIR/godot ]]; then
  (set -x;
    rm -rf $GODOT_DIR
    mkdir -p $GODOT_DIR
    unzip $GODOT_ARCHIVE -d $OUT
    mv $OUT/$(basename -s ".${GODOT_ARCHIVE##*.}" "$GODOT_ARCHIVE") "$GODOT_DIR/godot"
  )
fi

if [[ "$FORCE" == "1" || ! -x "$GODOT_BIN" ]]; then
  cp -a "$GODOT_DIR/godot"
fi

# extract templates
TEMPLATES_DIR=$HOME/.local/share/godot/export_templates/$(sed -e 's/-/./g' <<< "$GODOT_VERSION")
mkdir -p $(dirname "$TEMPLATES_DIR")
if [[ "$FORCE" == "1" || ! -d $TEMPLATES_DIR ]]; then
  (set -x;
    rm -rf $TEMPLATES_DIR
    unzip $GODOT_TEMPLATES -d $OUT
    mv $OUT/templates $TEMPLATES_DIR
  )
fi

echo "INSTALLED: $($GODOT_BIN --version)"
