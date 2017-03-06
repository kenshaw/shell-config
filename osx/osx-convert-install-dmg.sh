#!/bin/bash

# taken from different websites, but main basis: http://sqar.blogspot.de/2014/10/installing-yosemite-in-virtualbox.html
# also: https://www.howtogeek.com/289594/how-to-install-macos-sierra-in-virtualbox-on-windows-10/

APP_PATH=$(realpath /Applications/Install*.app)
DMG_PATH="$APP_PATH/Contents/SharedSupport/InstallESD.dmg"

RELEASE=$(basename "$APP_PATH" .app|cut -d' ' -f4)
if [ -z "$RELEASE" ]; then
  RELEASE=$(basename "$APP_PATH" .app|cut -d' ' -f3)
fi
RELEASE=$(echo $RELEASE|tr '[:upper:]' '[:lower:]')

if [ -z "$RELEASE" ]; then
  echo "unknown release"
  exit 1
fi

INST_PATH=/Volumes/install_$RELEASE
BUILD_PATH=/Volumes/build_$RELEASE
SPARSE_PATH=/tmp/$RELEASE.sparseimage

OUT=$HOME/osx-install-$RELEASE.iso

echo "RELEASE: $RELEASE"
echo "APP_PATH: $APP_PATH"
echo "DMG_PATH: $DMG_PATH"
echo "INST_PATH: $INST_PATH"
echo "BUILD_PATH: $BUILD_PATH"
echo "SPARSE_PATH: $SPARSE_PATH"
echo "OUT: $OUT"

set -ex

# mount installer image
hdiutil attach "$DMG_PATH" -noverify -nobrowse -mountpoint $INST_PATH

# create sparse image
hdiutil create -type SPARSE -size 8g -layout SPUD -fs HFS+J -o $(dirname $SPARSE_PATH)/$(basename $SPARSE_PATH .sparseimage)

# mount the sparse bundle for package addition
hdiutil attach $SPARSE_PATH -noverify -nobrowse -mountpoint $BUILD_PATH

# restore install image
asr restore -source $INST_PATH/BaseSystem.dmg -noprompt -noverify -erase -target $BUILD_PATH

# detach and reattach
hdiutil detach "/Volumes/OS X Base System"
hdiutil attach $SPARSE_PATH -noverify -nobrowse -mountpoint $BUILD_PATH

# remove Packages link and replace with actual files and copy base sistem
rm $BUILD_PATH/System/Installation/Packages
cp -rp $INST_PATH/Packages $BUILD_PATH/System/Installation/
cp -rp $INST_PATH/BaseSystem.dmg $BUILD_PATH/
cp -rp $INST_PATH/BaseSystem.chunklist $BUILD_PATH/

# unmount the installer image
hdiutil detach $INST_PATH

# unmount the sparse bundle
hdiutil detach $BUILD_PATH

# resize the partition in the sparse bundle to remove any free space
SZ=$(hdiutil resize -limits $SPARSE_PATH | tail -n 1 | awk '{ print $1 }')
hdiutil resize -size "${SZ}b" $SPARSE_PATH

# convert the sparse bundle to ISO/CD master
hdiutil convert $SPARSE_PATH -format UDTO -o $OUT

# rename
mv $OUT.cdr $OUT

# remove the sparse bundle
rm $SPARSE_PATH
