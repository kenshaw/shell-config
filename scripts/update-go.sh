#!/bin/bash

ARCH=amd64
DEST=/usr/local
PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]')
UPDATE=0
VERSION=master

OPTIND=1
while getopts "adpuv:" opt; do
case "$opt" in
  a) ARCH=$OPTARG ;;
  d) DEST=$OPTARG ;;
  p) PLATFORM=$OPTARG ;;
  u) UPDATE=1 ;;
  v) VERSION=$OPTARG ;;
esac
done

REPO=https://go.googlesource.com/go
DL=https://golang.org/dl/
EXT=tar.gz
SED=sed
AWK=awk

case $PLATFORM in
  windows)
    EXT=zip
  ;;
  darwin)
    SED=gsed
    AWK=gawk
  ;;
esac

set -e

LATEST=$(wget -qO- "$DL"|$SED -E -n "/<a .+?>go1\.[0-9]+(\.[0-9]+)?\.$PLATFORM-$ARCH\.$EXT</p"|head -1)
ARCHIVE=$($SED -E -e 's/.*<a .+?>(.+?)<\/a.*/\1/' <<< "$LATEST")
STABLE=$($SED -E -e 's/^go//' -e "s/\.$PLATFORM-$ARCH\.$EXT$//" <<< "$ARCHIVE")
REMOTE=$($SED -E -e 's/.*<a .+?href="(.+?)".*/\1/' <<< "$LATEST")

echo "DEST:    $DEST"
echo "STABLE:  $STABLE ($REMOTE)"
echo "VERSION: $VERSION"

grab() {
  echo -n "    "
  wget --progress=dot -O $2 $1 2>&1 |\
    grep --line-buffered "%" | \
    $SED -u -e "s,\.,,g" | \
    $AWK '{printf("\b\b\b\b%4s", $2)}'
  echo -ne "\b\b\b\b"
  echo " DONE"
}

if [ "$UPDATE" != "1" ]; then
  echo "not updating; try -u"
  exit 1
fi

if [ "$USER" != "root" ]; then
  echo "not root!"
  exit 1
fi

# reset git
if [ ! -d $DEST/go ]; then
  echo "CLONING: $REPO -> $DEST/go"
  git clone $REPO $DEST/go
fi

# extract
if [ ! -d $DEST/go-$STABLE ]; then
  OUT=$(mktemp -d)

  echo "RETRIEVING: $REMOTE -> $OUT/$ARCHIVE"
  grab $REMOTE $OUT/$ARCHIVE

  pushd $OUT &> /dev/null
  case $EXT in
    tar.gz)
      tar -zxf $ARCHIVE
      ;;
    zip)
      unzip $ARCHIVE
      ;;
  esac

  echo "MOVING: $OUT/go -> $DEST/go-$STABLE"
  mv go $DEST/go-$STABLE
  chown root:root -R $DEST/go-$STABLE

  popd &> /dev/null
fi

export GOROOT_BOOTSTRAP=$DEST/go-$STABLE

echo "BUILDING: $VERSION"
pushd $DEST/go &> /dev/null

# checkout
git fetch origin
git reset --hard
git checkout $VERSION

# pull if on branch
if [ ! -z "$(git symbolic-ref -q HEAD || :)" ]; then
  git pull
fi

git clean -f -x -d

# build
pushd src &> /dev/null
./make.bash
popd &> /dev/null

popd &> /dev/null
