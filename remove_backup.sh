#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

EFI=`./mount_efi.sh`
rm -rf $EFI/EFI/CLOVER/config_backup
rm -rf $EFI/EFI/CLOVER/kexts_backup
rm -rf $EFI/EFI/CLOVER/ACPI/patched_backup

echo Done!
