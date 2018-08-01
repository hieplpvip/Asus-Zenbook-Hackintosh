#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

PS3='Select model: '
options=("UX410 (KabyLake)" "UX430 (KabyLake)" "UX430 (KabyLake-R)")
select opt in "${options[@]}"
do
    case $opt in
        "UX410 (KabyLake)")
            config="config/config_ux410_kabylake.plist"
            product="MacBookPro14,1"
            break;;
        "UX430 (KabyLake)")
            config="config/config_ux430_kabylake.plist"
            product="MacBookPro14,1"
            break;;
        "UX430 (KabyLake-R)")
            config="config/config_ux430_kabylaker.plist"
            product="MacBookPro14,1"
            break;;
        *) echo "Invalid";;
    esac
done
echo

echo Mounting EFI...
EFI=`./mount_efi.sh`
EFIconfig=$EFI/EFI/CLOVER/config.plist
BAKconfig=$EFI/EFI/CLOVER/config_bak.plist
if [ -f $EFIconfig ]; then
    echo "Found config.plist in EFI. Rename to config_bak.plist"
    rm -f $BAKconfig
    mv $EFIconfig $BAKconfig
fi

cp $config $EFIconfig
if [ -f $BAKconfig ]; then
    echo "Restoring SMBIOS..."
    /usr/libexec/PlistBuddy -c "Delete :SMBIOS" $EFIconfig
    /usr/libexec/PlistBuddy -c "Add :SMBIOS dict" $EFIconfig
    ./merge_plist.sh "SMBIOS" $BAKconfig $EFIconfig
    /usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName $product" $EFIconfig
fi

echo
echo Done!
