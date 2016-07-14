#!/bin/bash

SDK_MIN=16

SDK_PAGE="https://developer.android.com/studio/index.html"
SDK_DLDIR="//dl.google.com/android"
SDK_REGEX="android-sdk_r[0-9\.]\+-linux.tgz"

# exclude and include packages
SDK_INCL=""
SDK_EXCL="doc- sample- sys-img- extra-android-gapid extra-google-auto addon-google_gdk- extra-android-m2repository"

DEST_DIR=$1
if [ -z "${DEST_DIR}" ]; then
  DEST_DIR=/media/src
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "INVALID DESTINATION: ${DEST_DIR}"
  exit 1
fi

# hackish so as to not need to continually redownload build-tools
if [ ! -d "${DEST_DIR}/android-sdk-linux/build-tools/23.0.2" ]; then
  SDK_INCL="build-tools-23.0.2 ${SDK_INCL}"
fi

if [ ! -d "${DEST_DIR}/android-sdk-linux/extras/android/m2repository" ]; then
  SDK_INCL="extra-android-m2repository ${SDK_INCL}"
fi

# reformat SDK_EXCL
SDK_EXCL="^\\($(sed -e 's/\s\+/\\|/g' <<< "$SDK_EXCL")\\)"

NL=$'\n'

set -ex

if [ ! -d  "${DEST_DIR}/android-sdk-linux" ]; then
  # get the sdk latest version
  SDK_LATEST=$(wget -qO- "${SDK_PAGE}" |sed -n "s|.*href=\"${SDK_DLDIR}/\(${SDK_REGEX}\)\".*|\1|p")

  # download sdk file if it doesn't exist
  SDK_FILE="${DEST_DIR}/${SDK_LATEST}"
  if [ ! -e "${SDK_FILE}" ]; then
    wget -O "${DEST_DIR}/${SDK_LATEST}" "https:${SDK_DLDIR}/${SDK_LATEST}"
  fi

  pushd ${DEST_DIR} &> /dev/null

  tar -zxf $SDK_LATEST

  popd &> /dev/null
fi

ANDROID_CMD="${DEST_DIR}/android-sdk-linux/tools/android"

# get available packages, minus excluded
PKGS_ALL=$($ANDROID_CMD list sdk --extended|sed -n 's/^id:\s*[0-9]\+\s*or\s*"\([^"]\+\)"/\1/p'|sed -n "/${SDK_EXCL}/ !p")

# select only versions >= SDK_MIN
PKGS_OTHER=$(egrep -v '(android|google)-[0-9]+$' <<< "$PKGS_ALL")
PKGS_ANDROID=$(egrep '(android|google)-[0-9]+$' <<< "$PKGS_ALL"|awk -F- "(\$NF>=${SDK_MIN})"|tr ' ' '-')

# generate list of all install packages
PKGS_INSTALL=$(tr ' ' '\n' <<< "${PKGS_ANDROID}${NL}${PKGS_OTHER}${NL}${SDK_INCL}"|sed -e '/^\s*$/d'|tr '\n' ','|sed -e 's/,$//')

if [ ! -z "$PKGS_INSTALL" ]; then
  # update packages
  expect -c "
  set timeout -1;
  spawn $ANDROID_CMD update sdk --no-ui --all --filter ${PKGS_INSTALL};
  expect {
    \"Do you accept the license\" { exp_send \"y\r\" ; exp_continue }
    eof
  }"
fi
