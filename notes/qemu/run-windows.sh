#!/bin/bash

# https://computernewb.com/wiki/QEMU/Guests/Windows_11
#
# qemu-img create -f qcow2 disk.qcow2 100G
#
# On first boot install when at the first (Language) screen, use Shift+F10 and enter the following:
#
# reg add HKLM\SYSTEM\Setup\LabConfig
# reg add HKLM\SYSTEM\Setup\LabConfig /t REG_DWORD /v BypassTPMCheck /d 1
# reg add HKLM\SYSTEM\Setup\LabConfig /t REG_DWORD /v BypassSecureBootCheck /d 1
# reg add HKLM\SYSTEM\Setup\LabConfig /t REG_DWORD /v BypassRAMCheck /d 1
# reg add HKLM\SYSTEM\Setup\LabConfig /t REG_DWORD /v BypassCPUCheck /d 1
#
# On second boot, when asked to sign in to Microsoft, use Shift+F10 and enter the following:
#
# start ms-cxh:localonly
#
# On third boot, remove the -cdrom flag/arg below

qemu-system-x86_64 \
  -M q35,usb=on,acpi=on,hpet=off \
  -m 6G \
  -cpu host,hv_relaxed,hv_frequencies,hv_vpindex,hv_ipi,hv_tlbflush,hv_spinlocks=0x1fff,hv_synic,hv_runtime,hv_time,hv_stimer,hv_vapic \
  -smp cores=4 \
  -accel kvm \
  -drive file=disk.qcow2 \
  -device usb-tablet \
  -device VGA,vgamem_mb=256 \
  -nic user,model=e1000 \
  -monitor stdio #\
#  -cdrom $HOME/Downloads/Win11_24H2_English_x64.iso
