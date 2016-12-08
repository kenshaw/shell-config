#!/bin/bash

if [ -z "$1" ]; then
  echo "please specify the name of the package to monitor or --restart as first parameter"
  exit 1
fi


PKG=$1
if [ "$1" == "--restart" ]; then
  PKG=$2

  if [ -z "$PKG" ]; then
    echo "must specify package name as second parameter"
  fi

  # stop package
  adb shell am force-stop $PKG


  # start app via click
  adb shell monkey -p $PKG -c android.intent.category.LAUNCHER 1
fi

set -e

# sleep
sleep 0.5s

# grab PID of process
PID=$(adb shell ps | grep $PKG | cut -c10-15)

echo ">>> MONITORING: $PID"

adb logcat | grep $PID
