#!/bin/bash

set -x -e

SDK_PAGE="https://developer.android.com/sdk/index.html"
SDK_DLDIR="http://dl.google.com/android"
SDK_REGEX="android-sdk_r[0-9\.]\+-linux.tgz"

DEST_DIR=$1
if [ -z "${DEST_DIR}" ]; then
  DEST_DIR=/media/src
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "INVALID DESTINATION: ${DEST_DIR}"
  exit 1
fi

if [ ! -d  "${DEST_DIR}/android-sdk-linux" ]; then
  # get the sdk latest version
  SDK_LATEST=$(wget -qO- "${SDK_PAGE}" |sed -n "s|.*href=\"${SDK_DLDIR}/\(${SDK_REGEX}\)\".*|\1|p")

  # download sdk file if it doesn't exist
  SDK_FILE="${DEST_DIR}/${SDK_LATEST}"
  if [ ! -e "${SDK_FILE}" ]; then
    wget -O "${DEST_DIR}/${SDK_LATEST}" "${SDK_DLDIR}/${SDK_LATEST}"
  fi

  pushd ${DEST_DIR} &> /dev/null

  tar -zxf $SDK_LATEST

  popd &> /dev/null
fi

ANDROID_CMD="${DEST_DIR}/android-sdk-linux/tools/android"

# get package lists
SDK_PKGS=$($ANDROID_CMD list sdk --all|sed -n 's/^\s*\([0-9]\+\)-.*/\1/p'|tr "\n" ,)

# update android
expect -c "
set timeout -1;
spawn $ANDROID_CMD update sdk -u -a -t $SDK_PKGS;
expect {
    \"Do you accept the license\" { exp_send \"y\r\" ; exp_continue }
    eof
}"
