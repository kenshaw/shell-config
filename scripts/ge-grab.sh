#!/bin/bash

REPO=GloriousEggroll/proton-ge-custom
OUT=$HOME/.steam/root/compatibilitytools.d
URL="https://github.com/%s/releases/download/%s/%s.tar.gz"
SHA=$(sed -e 's/\.tar\.gz$/.sha512sum/' <<< "$URL")

set -e

mkdir -p $OUT

CLEAN=0
DOWNLOAD=0
FORCE=
VERSION=

OPTIND=1
while getopts "cdfv:" opt; do
case "$opt" in
  c) CLEAN=1 ;;
  d) DOWNLOAD=1 ;;
  f) FORCE=1 ;;
  v) VERSION=$OPTARG ;;
esac
done

github_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

if [ -z "$VERSION" ]; then
  VERSION=$(github_release "$REPO")
fi

DL=$(printf "$URL" $REPO $VERSION $VERSION)

echo "VERSION:   $VERSION"
echo "OUT:       ~${OUT#$HOME}"
echo "INSTALLED: $(ls -d $OUT/*|grep -v '.tar.gz'|sed -e "s%$OUT/%%g"|xargs)"
echo "DL:        $DL"
echo "CLEAN:     $CLEAN"

if [ "$DOWNLOAD" = "1" ]; then
  if [ "$FORCE" == "1" ]; then
    rm -rf $OUT/$VERSION.tar.gz $OUT/$VERSION
  fi

  if [ ! -f $OUT/$VERSION.tar.gz ]; then
    curl -4 -L -# -o $OUT/$VERSION.tar.gz "$DL"
  fi
fi

CHECKSUM=$(curl -4 -L -s "$(printf "$SHA" $VERSION $VERSION)"|awk '{print $1}')
SIG=$(sha512sum $OUT/$VERSION.tar.gz|awk '{print $1}')

if [ "$CHECKSUM" != "$SIG" ]; then
  echo -e "error: invalid signature: $CHECKSUM != $SIG\n\ntry:\n\n  rm -f ~/${OUT#$HOME/}/$VERSION.tar.gz\n\nand then run again!"
  exit 1
fi

echo "SIGNATURE: valid"

if [ ! -d $OUT/$VERSION ]; then
  tar -xf $OUT/$VERSION.tar.gz -C $OUT
fi

if [ "$CLEAN" = "1" ]; then
  REMOVE=$(cut -d- -f1-2 <<< "$VERSION")
  (set -x;
    find $OUT -maxdepth 1 -iname "$REMOVE*" -not -iname "$VERSION*" -exec rm -rf {} \;
  )
fi

if [[ "$DOWNLOAD" == "1" || "$CLEAN" == "1" ]]; then
  echo "INSTALLED: $(ls -d $OUT/*|grep -v '.tar.gz'|sed -e "s%$OUT/%%g"|xargs)"
fi
