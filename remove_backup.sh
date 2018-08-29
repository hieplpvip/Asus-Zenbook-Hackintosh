#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

. ./src/config.txt

EFI=`./mount_efi.sh`
rm -rf $EFI/$ACPIBAK
rm -rf $EFI/$CONFIGBAK
rm -rf $EFI/$KEXTSBAK

echo Done!
