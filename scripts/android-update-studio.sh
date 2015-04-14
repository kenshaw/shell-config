#!/bin/bash

set -x -e

STUDIO_PAGE="https://developer.android.com/sdk/index.html"
STUDIO_REGEX="https://dl.google.com/dl/android/studio/ide-zips/[0-9\.]\+/android-studio-ide-[0-9\.]\+-linux\.zip"

DEST_DIR=$1
if [ -z "${DEST_DIR}" ]; then
  DEST_DIR=/media/src
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "INVALID DESTINATION: ${DEST_DIR}"
  exit 1
fi

if [ ! -d  "${DEST_DIR}/android-studio" ]; then
  # get the sdk latest version
  STUDIO_DLPATH=$(wget -qO- "${STUDIO_PAGE}" |sed -n "s|.*href=\"\(${STUDIO_REGEX}\)\".*|\1|p")
  STUDIO_LATEST=$(echo "${STUDIO_DLPATH}" |sed -e 's/.*\/\([a-z0-9\.\-]\)/\1/i')

  # download sdk file if it doesn't exist
  STUDIO_FILE="${DEST_DIR}/${STUDIO_LATEST}"
  if [ ! -e "${STUDIO_FILE}" ]; then
    wget -O "${DEST_DIR}/${STUDIO_LATEST}" "${STUDIO_DLPATH}"
  fi

  pushd ${DEST_DIR} &> /dev/null

  unzip $STUDIO_LATEST

  popd &> /dev/null
fi
