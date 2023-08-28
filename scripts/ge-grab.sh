#!/bin/bash

REPO=GloriousEggroll/proton-ge-custom
OUT=$HOME/.steam/root/compatibilitytools.d
URL='https://github.com/GloriousEggroll/proton-ge-custom/releases/download/%s/%s.tar.gz'
SHA=$(sed -e 's/\.tar\.gz$/.sha512sum/' <<< "$URL")

set -e

mkdir -p $OUT

VERSION=
DOWNLOAD=0

OPTIND=1
while getopts "dv:" opt; do
case "$opt" in
  d) DOWNLOAD=1 ;;
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

DL=$(printf "$URL" $VERSION $VERSION)

echo "VERSION:   $VERSION"
echo "DL:        $DL"

if [ "$DOWNLOAD" != "1" ]; then
  exit
fi

if [ ! -f $OUT/$VERSION.tar.gz ]; then
  curl -4 -L -# -o $OUT/$VERSION.tar.gz "$DL"
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
