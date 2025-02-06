Change `ScanPolicy` and `Timeout` in the OpenCore boot `config.plist`:

https://github.com/quickemu-project/quickemu/issues/1259

```sh
sudo -i
efi_part=/dev/$(diskutil list | grep EFI | grep -v disk0 | awk '{ print $6 }')
config_plist=/Volumes/EFI/EFI/OC/config.plist
diskutil mount $efi_part
plutil -replace ScanPolicy -integer 769 $config_plist
plutil -replace Timeout -integer 2 $config_plist
disutil unmount $efi_part
reboot
```
