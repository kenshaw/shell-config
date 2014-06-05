#!/bin/bash

VM="$1"

VBoxManage setextradata "$VM" VBoxInternal2/EfiGopMode 2
VBoxManage setextradata "$VM" VBoxInternal2/SmcDeviceKey 'ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc'

# from: http://martinml.com/en/how-to-install-mac-os-x-snow-leopard-in-virtualbox/
# after install, do this on OS X guest (and then reboot):

# sudo rm /System/Library/Extensions/AppleIntelCPUPowerManagement.kext
# sudo kextcache -system-caches
