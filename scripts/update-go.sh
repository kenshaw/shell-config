#!/bin/bash

DEST=/usr/local
FORCE=0
UPDATE=0
VERSION=master

OPTIND=1
while getopts "dfuv:" opt; do
case "$opt" in
  d) DEST=$OPTARG ;;
  f) FORCE=1 ;;
  u) UPDATE=1 ;;
  v) VERSION=$OPTARG ;;
esac
done

REPO=https://go.googlesource.com/go
DL=https://golang.org/dl/

ARCH=amd64
PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]')

EXT=tar.gz
SED=sed
AWK=awk

case $PLATFORM in
  windows)
    DEST=/c
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

echo "DEST:     $DEST"
echo "EXISTING: $([ -e $DEST/go/bin/go ] && $DEST/go/bin/go version)"
echo "STABLE:   $STABLE ($REMOTE)"
echo "VERSION:  $VERSION"

grab() {
  echo -n "RETRIEVING: $1 -> $2     "
  wget --progress=dot -O $2 $1 2>&1 |\
    grep --line-buffered "%" | \
    $SED -u -e "s,\.,,g" | \
    $AWK '{printf("\b\b\b\b%4s", $2)}'
  echo -ne "\b\b\b\b"
  echo " DONE."
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

CURRENT=$(git rev-parse HEAD)

# checkout
git fetch origin
git reset --hard
git checkout $VERSION

# if we're on a branch
if [ ! -z "$(git symbolic-ref -q HEAD || :)" ]; then
  git pull
fi
VERSION=$(git rev-parse HEAD)

if [[ "$CURRENT" != "$VERSION" || "$FORCE" == "1" ]]; then
  git clean -f -x -d

  # build
  pushd src &> /dev/null
  ./make.bash
  popd &> /dev/null
fi

popd &> /dev/null

echo "INSTALLED: $($DEST/go/bin/go version)"
