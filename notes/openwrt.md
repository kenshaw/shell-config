# dlink dir-878

## RS232 pin layout

1. Red   - Power
2. Green - Transfer (TX)
3. White - Receive (RX)
4. Black - Ground (GND)

## Upload firmware

1. Put device in recovery mode
2. Manually configure ethernet IP to `192.168.0.2`
2. Open [http://192.168.0.1](http://192.168.0.1)
3. Upload `factory` build with `curl` (upload via browser will not work):

```sh
curl -v -i -F "firmware=@openwrt-factory.bin" 192.168.0.1
```

## Connect to TTY

```
picocom -b 57600 /dev/ttyUSB0
```

# netgear r7800

## Upload firmware

1. Put device in recovery mode
2. Manually configure ethernet IP to `192.168.1.10` and connect cable to port 4
3. Upload `factory` firmware via `tftp`:

```sh
$ sudo aptitude install tftp
$ tftp 192.168.1.1
tftp> binary
tftp> put openwrt-factory.img
Sent 13238401 bytes in 1.6 seconds
tftp> quit
```
