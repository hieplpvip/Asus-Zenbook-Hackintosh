#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

SLE=/System/Library/Extensions
LE=/Library/Extensions

OLDKEXTS="ACPIBatteryManager|ACPIPoller|AppleALC|aDummyHDA|AppleBacklightInjector|AppleBacklightFixup|IntelBacklight|Asus|AirportBrcmFixup|BrcmPatchRAM2|BrcmFirmware|BT4LEContiunityFixup|CodecCommander|FakePCIID|FakeSMC|WhateverGreen|IntelGraphicsFixup|NvidiaGraphicsFixup|CoreDisplayFixup|Shiki|Lilu|NullEthernet|USBInjectAll|VoodooI2C|VoodooPS2Controller"

for kext in $LE/*.kext; do
    kextname="`basename $kext`"
    if [[ "`echo $kextname | grep -E $OLDKEXTS`" != "" ]]; then
        echo Removing $kext...
        sudo rm -Rf $kext
    fi
done

for kext in $SLE/*.kext; do
    kextname="`basename $kext`"
    if [[ "`echo $kextname | grep -E $OLDKEXTS`" != "" ]]; then
        echo Removing $kext...
        sudo rm -Rf $kext
    fi
done

# force cache rebuild with output
echo Rebuilding kextcache...
sudo kextcache -i /
echo

echo Done.
