#!/bin/bash

# taken from different websites, but main basis: http://sqar.blogspot.de/2014/10/installing-yosemite-in-virtualbox.html

set -x -e

APP_PATH=$(ls -d /Applications/Install\ OS\ X\ *.app)
DMG_PATH="${APP_PATH}/Contents/SharedSupport/InstallESD.dmg"
RELEASE=$(basename "${APP_PATH}" .app|cut -d' ' -f4)

# Mount the installer image
hdiutil attach "${DMG_PATH}" -noverify -nobrowse -mountpoint /Volumes/${RELEASE}_app

# Convert the boot image to a sparse bundle
hdiutil convert /Volumes/${RELEASE}_app/BaseSystem.dmg -format UDSP -o /tmp/${RELEASE}

# Increase the sparse bundle capacity to accommodate the packages
hdiutil resize -size 8g /tmp/${RELEASE}.sparseimage

# Mount the sparse bundle for package addition
hdiutil attach /tmp/${RELEASE}.sparseimage -noverify -nobrowse -mountpoint /Volumes/${RELEASE}_build

# Remove Package link and replace with actual files
rm /Volumes/${RELEASE}_build/System/Installation/Packages
cp -rp /Volumes/${RELEASE}_app/Packages /Volumes/${RELEASE}_build/System/Installation/

# Copy Base System
cp -rp /Volumes/${RELEASE}_app/BaseSystem.dmg /Volumes/${RELEASE}_build/
cp -rp /Volumes/${RELEASE}_app/BaseSystem.chunklist /Volumes/${RELEASE}_build/

# Unmount the installer image
hdiutil detach /Volumes/${RELEASE}_app

# Unmount the sparse bundle
hdiutil detach /Volumes/${RELEASE}_build

# Resize the partition in the sparse bundle to remove any free space
hdiutil resize -size `hdiutil resize -limits /tmp/${RELEASE}.sparseimage | tail -n 1 | awk '{ print $1 }'`b /tmp/${RELEASE}.sparseimage

# Convert the sparse bundle to ISO/CD master
hdiutil convert /tmp/${RELEASE}.sparseimage -format UDTO -o /tmp/${RELEASE}

# Remove the sparse bundle
rm /tmp/${RELEASE}.sparseimage

# Rename the ISO and move it to the desktop
mv /tmp/${RELEASE}.cdr $HOME/${RELEASE}.iso
