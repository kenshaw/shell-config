#!/bin/bash

SDK_INDEX="https://developer.android.com/studio/index.html"

SEDBIN=sed

DEST=/media/src

PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]')
case $PLATFORM in
  mingw64|msys)
    PLATFORM=windows
    DEST=/opt
  ;;

  darwin)
    SEDBIN=gsed
    DEST=/opt
  ;;
esac

if [ ! -d "$DEST" ]; then
  echo "INVALID DESTINATION: $DEST"
  exit 1
fi

SDK_DIR="$DEST/android-sdk-$PLATFORM"

if [ ! -d "$SDK_DIR" ]; then
  # get the sdk latest version
  SDK_LATEST=$(wget -qO- "$SDK_INDEX" |$SEDBIN -n "s|.*href=\"\(https://dl.google.com/android/repository/sdk-tools-$PLATFORM-[0-9\.]\+\.zip\)\".*|\1|p")

  # download sdk file if it doesn't exist
  SDK_FILE="$DEST/$(basename "$SDK_LATEST")"
  if [ ! -e "$SDK_FILE" ]; then
    wget -O "$SDK_FILE" "$SDK_LATEST"
  fi

  pushd $DEST &> /dev/null

  mkdir -p "$SDK_DIR"

  unzip -q "$SDK_FILE" -d "$SDK_DIR"

  popd &> /dev/null
fi

SDK_MGR="$SDK_DIR/tools/bin/sdkmanager"

$SDK_MGR ndk-bundle
$SDK_MGR --update
