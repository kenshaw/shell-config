# macOS vm notes

## Forward from remote host:

```sh
$ ssh -L 5930:127.0.0.1:5930 <host>
```

## Access with:

```sh
$ spicy --title "macos-sequoia" --port 5930
```

## Fix auto boot partition selection

See: https://github.com/quickemu-project/quickemu/issues/1259

Change `ScanPolicy` and `Timeout` in the OpenCore boot `config.plist`:

```sh
sudo -i
efi_part=/dev/$(diskutil list | grep EFI | grep -v disk0 | awk '{ print $6 }')
config_plist=/Volumes/EFI/EFI/OC/config.plist
diskutil mount $efi_part
plutil -replace ScanPolicy -integer 769 $config_plist
plutil -replace Timeout -integer 2 $config_plist
diskutil unmount $efi_part
reboot
```

## Fix apple login issues

See: https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#using-macserial
