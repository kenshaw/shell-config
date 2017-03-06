#!/bin/bash

VM=$1

if [ -z "$VM" ]; then
  echo "usage: $0 <VM>"
  exit 1
fi

SMC_DEVICE_KEY='ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc'

set -ex

VBoxManage setextradata "$VM" VBoxInternal2/EfiGopMode 2
VBoxManage setextradata "$VM" VBoxInternal2/SmcDeviceKey "$SMC_DEVICE_KEY"

#VBoxManage modifyvm     "$VM" --cpuidset 00000001 000306a9 04100800 7fbae3ff bfebfbff
#VBoxManage setextradata "$VM" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "MacBookPro11,3"
#VBoxManage setextradata "$VM" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
#VBoxManage setextradata "$VM" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Mac-2BD1B31983FE1663"
#VBoxManage setextradata "$VM" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "$SMC_DEVICE_KEY"
#VBoxManage setextradata "$VM" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1

# if booting, and its a black screen, the assigned ram amount is too high (must be 3 gigs or less)
# from: http://martinml.com/en/how-to-install-mac-os-x-snow-leopard-in-virtualbox/
# after install, do this on OS X guest (and then reboot):

# sudo rm /System/Library/Extensions/AppleIntelCPUPowerManagement.kext
# sudo kextcache -system-caches
