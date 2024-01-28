# USB reset
usbreset -- send a USB port reset to a USB device

Compile using: gcc -o usbreset usbreset.c


## Usage

```bash
$resetdevice = $(lsusb | grep Serial | awk '{print $2,$4}' | sed 's/://' | tr -s '[:blank:]' '/')
chmod +x $PWD/usbreset/usbreset
./usbreset /dev/bus/usb/$resetdevice
```