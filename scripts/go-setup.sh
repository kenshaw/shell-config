#!/bin/bash

# on osx, run the following to fix issues with scripts:
#    port install coreutils gawk gsed

ARCH=amd64
PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]'|sed -e 's/^\(msys\|mingw\).*/windows/')

REPO=https://go.googlesource.com/go
DL=https://go.dev/dl/

MAKECMD=make.bash
EXT=tar.gz
SED=sed
AWK=awk
ROOTUSER=root
ROOTGROUP=root

DEST=/usr/local
CLEAN=0
FORCE=0
UPDATE=0

case $PLATFORM in
  darwin)
    SED=gsed
    AWK=gawk
    ROOTGROUP=wheel
    ARCH=$(uname -a|$AWK '{print $NF}')
    if [[ "$ARCH" == "x86_64" ]]; then
      ARCH=amd64
    fi
  ;;
  windows)
    DEST=/c
    EXT=zip
    MAKECMD=make.bat
  ;;
esac

set -e

LATEST=$(curl -4 -s "$DL"|$SED -E -n "/<a .+?>go1\.[0-9]+(\.[0-9]+)?\.$PLATFORM-$ARCH\.$EXT</p"|head -1)
ARCHIVE=$($SED -E -e 's/.*<a .+?>(.+?)<\/a.*/\1/' <<< "$LATEST")
STABLE=$($SED -E -e 's/^go//' -e "s/\.$PLATFORM-$ARCH\.$EXT$//" <<< "$ARCHIVE")

if ! [[ "$STABLE" =~ ^1\.[0-9\.]+$ ]]; then
  echo "ERROR: unable to retrieve latest Go version for $PLATFORM/$ARCH ($STABLE)"
  exit 1
fi

REMOTE=$($SED -E -e 's/.*<a .+?href="(.+?)".*/\1/' <<< "$LATEST")
VERSION="go$STABLE"
CACHE=

OPTIND=1
while getopts "cC:d:fuv:" opt; do
case "$opt" in
  c) CLEAN=1 ;;
  C) CACHE=$OPTARG ;;
  d) DEST=$OPTARG ;;
  f) FORCE=1 ;;
  u) UPDATE=1 ;;
  v) VERSION=$OPTARG ;;
esac
done

# prefix passed version with go
if [[ "$VERSION" =~ ^1\.[0-9\.]+ ]]; then
  VERSION="go$VERSION"
fi

if ! [[ "$VERSION" =~ ^go1\.[0-9]+\.[0-9]+$ ]]; then
  echo "ERROR: invalid Go version $VERSION"
  exit 1
fi

EXISTING="<none>"
if [ -x $DEST/go/bin/go ]; then
  EXISTING="$($DEST/go/bin/go version)"
fi

if ! [[ "$REMOTE" =~ "^https://" ]]; then
  REMOTE="https://go.dev$REMOTE"
fi

echo "DEST:       $DEST"
echo "EXISTING:   $EXISTING"
echo "STABLE:     $STABLE ($REMOTE)"
echo "VERSION:    $VERSION"

log() {
  cat - | while read -r message; do
    echo "$1$message"
  done
}

grab() {
  echo "RETRIEVING: $1 -> $2"
  curl -4 -L -# -o $2 $1
}

if [ "$UPDATE" != "1" ]; then
  echo "not updating; try -u"
  exit 1
fi

if [[ "$PLATFORM" != "windows" && "$USER" != "root" && "$FORCE" != "1" ]]; then
  echo "not root!"
  exit 1
fi

# clone
if [[ ! -d $DEST/go || ! -d $DEST/go/.git ]]; then
  echo "CLONING:    $REPO -> $DEST/go"
  git clone --quiet $REPO $DEST/go 2>&1 | log "CLONING:    "
  FORCE=1
fi

# extract
if [ ! -d $DEST/go-$STABLE ]; then
  WORKDIR=$(mktemp -d /tmp/go-setup.XXXX)
  if [ -z "$CACHE" ]; then
    grab $REMOTE $WORKDIR/$ARCHIVE
  else
    if [ ! -f $CACHE/$ARCHIVE ]; then
      grab $REMOTE $CACHE/$ARCHIVE
    fi
    echo "USING:      $CACHE/$ARCHIVE"
    ln -s $CACHE/$ARCHIVE $WORKDIR/$ARCHIVE
  fi

  pushd $WORKDIR &> /dev/null
  case $EXT in
    tar.gz) tar -zxf $ARCHIVE ;;
    zip)    unzip -q $ARCHIVE ;;
    *)
      echo "ERROR:      unknown extension $EXT"
      exit
    ;;
  esac

  echo "MOVING:     $WORKDIR/go -> $DEST/go-$STABLE"
  mv go $DEST/go-$STABLE

  if [ "$PLATFORM" != "windows" ]; then
    chown -R $ROOTUSER:$ROOTGROUP $DEST/go-$STABLE
  fi

  popd &> /dev/null
fi

# clean up old versions of $DEST/go-*
if [ "$CLEAN" = "1" ]; then
  for i in $DEST/go-*; do
    v=$(basename "$i"|sed -e 's/^go-//')
    if [[ "$v" == "$STABLE" || ! "$v" =~ ^1\.[0-9]+(\.[0-9]+)?$ ]]; then
      continue
    fi
    echo "REMOVING:   $i"
    rm -rf $i
  done
fi

export GOROOT_BOOTSTRAP=$DEST/go-$STABLE

pushd $DEST/go &> /dev/null

CURRENT=$(git rev-parse HEAD)

# checkout
git fetch origin 2>&1 | log "FETCHING:   "
git reset --hard 2>&1 | log "RESETTING:  "
git checkout -q $VERSION 2>&1| log "CHECKOUT:  "

# if we're on a branch
if [ ! -z "$(git symbolic-ref -q HEAD || :)" ]; then
  git pull 2>&1 | log "PULLING:    "
fi
VERSION=$(git rev-parse HEAD)

if [[ ! -d $DEST/go/bin || ! -x $DEST/go/bin/go ]]; then
  FORCE=1
fi

if [[ "$CURRENT" != "$VERSION" || "$FORCE" == "1" ]]; then
  git clean -f -x -d 2>&1 | log "CLEANING:   "

  # build
  pushd src &> /dev/null
  ./$MAKECMD 2>&1 | log "BUILDING:   "
  popd &> /dev/null
fi

if [ "$PLATFORM" != "windows" ]; then
  chown -R $ROOTUSER:$ROOTGROUP .
fi

popd &> /dev/null

echo "INSTALLED:  $($DEST/go/bin/go version)"

if [ "$PLATFORM" = "windows" ]; then
  cmd //c mklink /D C:\\msys64\\usr\\local\\go c:\\go
fi
