#!/bin/bash

DEFAULT_DEST=$HOME/src/sdk

SDK_PAGE="https://cloud.google.com/appengine/downloads"
SDK_DLDIR="https://storage.googleapis.com/appengine-sdks/featured"
SDK_DIR="go_appengine"
SDK_REGEX="go_appengine_sdk_linux_amd64-[0-9\.]\+\.zip"

AWKBIN=awk
SEDBIN=sed

# change paths for osx
if [[ "$PLATFORM" == "Darwin" ]]; then
  SDK_REGEX="go_appengine_sdk_darwin_amd64-[0-9\.]\+\.zip"

  AWKBIN=gawk
  SEDBIN=gsed
fi

DEST_DIR=$1
if [ -z "${DEST_DIR}" ]; then
  DEST_DIR=$DEFAULT_DEST
fi

if [ ! -d "${DEST_DIR}" ]; then
  DEST_DIR=$HOME/src/sdk
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "INVALID DESTINATION: ${DEST_DIR}"
  exit 1
fi

NL=$'\n'

set -ex

if [ ! -d  "${DEST_DIR}/${SDK_DIR}" ]; then
  # get the sdk latest version
  SDK_LATEST=$(wget -qO- "${SDK_PAGE}" |$SEDBIN -n "s|.*href=\"${SDK_DLDIR}/\(${SDK_REGEX}\)\".*|\1|p")

  # download sdk file if it doesn't exist
  SDK_FILE="${DEST_DIR}/${SDK_LATEST}"
  if [ ! -e "${SDK_FILE}" ]; then
    wget -O "${DEST_DIR}/${SDK_LATEST}" "${SDK_DLDIR}/${SDK_LATEST}"
  fi

  pushd ${DEST_DIR} &> /dev/null

  case "${SDK_LATEST}" in
    *.tgz)
      tar -zxf $SDK_LATEST ;;
    *.zip)
      unzip $SDK_LATEST ;;
    *)
      echo "ERROR: ${SDK_LATEST} is of unknown archive type"
      exit 1 ;;
  esac

  popd &> /dev/null
fi
