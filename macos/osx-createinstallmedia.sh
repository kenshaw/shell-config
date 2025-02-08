#!/bin/bash

# see:
#   http://sqar.blogspot.de/2014/10/installing-yosemite-in-virtualbox.html
#   https://www.howtogeek.com/289594/how-to-install-macos-sierra-in-virtualbox-on-windows-10/
#   https://astr0baby.wordpress.com/2018/09/25/running-macos-mojave-10-14-on-virtualbox-5-2-18-on-linux-x86_64/

APP_PATH=$(realpath /Applications/Install*.app)

RELEASE=$(basename "$APP_PATH" .app|cut -d' ' -f4)
if [ -z "$RELEASE" ]; then
  RELEASE=$(basename "$APP_PATH" .app|cut -d' ' -f3)
fi
RELEASE=$(echo $RELEASE|tr '[:upper:]' '[:lower:]')

if [ -z "$RELEASE" ]; then
  echo "unknown release"
  exit 1
fi

# sanity check version in plist
VERSION=$(defaults read "$APP_PATH/Contents/SharedSupport/InstallInfo" 'System Image Info'|grep version|cut -d'"' -f2)
if [[ ! $VERSION =~ ^10\.[0-9]+\.[0-9]+$ ]]; then
  echo "invalid version $VERSION"
  exit 1
fi

SPARSE_PATH=/tmp/install-${RELEASE}-${VERSION}.sparseimage
BUILD_PATH=/Volumes/install-${RELEASE}-${VERSION}
OUT=$HOME/install-${RELEASE}-${VERSION}.iso

echo "RELEASE:     $RELEASE ($VERSION)"
echo "APP_PATH:    $APP_PATH"
echo "SPARSE_PATH: $SPARSE_PATH"
echo "BUILD_PATH:  $BUILD_PATH"
echo "OUT:         $OUT"

set -ex

# remove any existing file
rm -f $SPARSE_PATH

# create sparse image
hdiutil create -type SPARSE -size 8g -layout SPUD -fs HFS+J -o $(dirname $SPARSE_PATH)/$(basename $SPARSE_PATH .sparseimage)

# mount sparse bundle for use with createinstallmedia
hdiutil attach $SPARSE_PATH -noverify -nobrowse -mountpoint $BUILD_PATH

# create install media
sudo "$APP_PATH/Contents/Resources/createinstallmedia" --nointeraction --downloadassets --volume $BUILD_PATH

# unmount sparse bundle
hdiutil detach "/Volumes/$(basename "$APP_PATH" .app)"

# resize partition in sparse bundle to remove any free space
SZ=$(hdiutil resize -limits $SPARSE_PATH | tail -n 1 | awk '{ print $1 }')
hdiutil resize -size "${SZ}b" $SPARSE_PATH

# convert sparse bundle to ISO/CD master
hdiutil convert $SPARSE_PATH -format UDTO -o $OUT

# rename
mv $OUT.cdr $OUT

# remove sparse bundle
rm $SPARSE_PATH
