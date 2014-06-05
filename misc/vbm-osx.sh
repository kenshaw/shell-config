#!/bin/bash

VM="$1"

VBoxManage setextradata "$VM" VBoxInternal2/EfiGopMode 2
VBoxManage setextradata "$VM" VBoxInternal2/SmcDeviceKey 'ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc'
