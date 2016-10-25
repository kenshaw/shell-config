#!/bin/bash

DEFAULT_DEST=/media/src

SDK_MIN=16

SDK_PAGE="https://developer.android.com/studio/index.html"
SDK_DLDIR="//dl.google.com/android"
SDK_DIR="android-sdk-linux"
SDK_REGEX="android-sdk_r[0-9\.]\+-linux\.tgz"

AWKBIN=awk
SEDBIN=sed

set -e

NL=$'\n'

# change paths for osx
if [[ "$PLATFORM" == "Darwin" ]]; then
  SDK_DIR="android-sdk-macosx"
  SDK_REGEX="android-sdk_r[0-9\.]\+-macosx\.zip"

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

if [ ! -d  "${DEST_DIR}/${SDK_DIR}" ]; then
  # get the sdk latest version
  SDK_LATEST=$(wget -qO- "${SDK_PAGE}" |$SEDBIN -n "s|.*href=\"${SDK_DLDIR}/\(${SDK_REGEX}\)\".*|\1|p")

  # download sdk file if it doesn't exist
  SDK_FILE="${DEST_DIR}/${SDK_LATEST}"
  if [ ! -e "${SDK_FILE}" ]; then
    wget -O "${DEST_DIR}/${SDK_LATEST}" "https:${SDK_DLDIR}/${SDK_LATEST}"
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

ANDROID_CMD="${DEST_DIR}/${SDK_DIR}/tools/android"

# exclude and include packages
SDK_INCL=""
SDK_EXCL="doc- sample- sys-img- extra-android-gapid extra-google-auto addon-google_gdk- extra-google-simulators extra-intel-"

# include extra build tool versions
for VER in 23.0.1 23.0.2 24.0.1 25.0.0; do
  if [ ! -d "${DEST_DIR}/${SDK_DIR}/build-tools/$VER" ]; then
    SDK_INCL="build-tools-$VER ${SDK_INCL}"
  fi
done

# exclude extra-android-m2repository if available > installed
SUPPORT_VER=$($ANDROID_CMD list sdk --extended |egrep 'Android Support Repository, revision'|$SEDBIN -e 's/.*revision\s*\(.*\)/\1/')
SUPPORT_VER=$(($SUPPORT_VER+0))
SUPPORT_MANIFEST="${DEST_DIR}/${SDK_DIR}/extras/android/m2repository/source.properties"
if [ -f "${SUPPORT_MANIFEST}" ]; then
  INST_VER=$($SEDBIN -n 's/^Pkg\.Revision=\([0-9]\+\).*/\1/p' $SUPPORT_MANIFEST)
  INST_VER=$(($INST_VER+0))
  if [ $SUPPORT_VER -le $INST_VER ]; then
    SDK_EXCL="extra-android-m2repository ${SDK_EXCL}"
  fi
fi

# reformat SDK_EXCL
SDK_EXCL="^\\($($SEDBIN -e 's/\s\+/\\|/g' <<< "$SDK_EXCL")\\)"

# get available packages, minus excluded
PKGS_ALL=$($ANDROID_CMD list sdk --extended|$SEDBIN -n 's/^id:\s*[0-9]\+\s*or\s*"\([^"]\+\)"/\1/p'|$SEDBIN -n "/${SDK_EXCL}/ !p")

# select only versions >= SDK_MIN
PKGS_OTHER=$(egrep -v '(android|google)-[0-9]+$' <<< "$PKGS_ALL")
PKGS_ANDROID=$(egrep '(android|google)-[0-9]+$' <<< "$PKGS_ALL"|$AWKBIN -F- "(\$NF>=${SDK_MIN})"|tr ' ' '-')

# generate list of all install packages
PKGS_INSTALL=$(tr ' ' '\n' <<< "${PKGS_ANDROID}${NL}${PKGS_OTHER}${NL}${SDK_INCL}"|$SEDBIN -e '/^\s*$/d'|tr '\n' ','|$SEDBIN -e 's/,$//')

if [ ! -z "$PKGS_INSTALL" ]; then
  echo "INSTALL: ${PKGS_INSTALL}"

  # only if --update=yes
  if [ "$1" == "--update=yes" ]; then
    # update packages
    expect -c "
    set timeout -1;
    spawn $ANDROID_CMD update sdk --no-ui --all --filter ${PKGS_INSTALL};
    expect {
      \"Do you accept the license\" { exp_send \"y\r\" ; exp_continue }
      eof
    }"

  else
    echo "NOTHING DONE! -- try --update=yes"
  fi
fi
