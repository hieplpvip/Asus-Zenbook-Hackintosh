#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

PS3='Select model: '
options=("UX310 (KabyLake)" "UX410 (KabyLake)" "UX430 (KabyLake)" "UX430 (KabyLake-R)")
select opt in "${options[@]}"
do
    case $opt in
        "UX310 (KabyLake)")
            config="config/config_ux310_kabylake.plist"
            product="MacBookPro14,1"
            break;;
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
BAKdir=$EFI/EFI/CLOVER/config_backup
if [ ! -d $BAKdir ]; then mkdir $BAKdir; fi

BAKconfig=$BAKdir/config_`date +%Y%m%d%H%M%S`.plist
if [ -f $EFIconfig ]; then
    echo "Found config.plist in EFI. Backing up..."
    mv $EFIconfig $BAKconfig
fi

cp $config $EFIconfig
if [ -f $BAKconfig ]; then
    echo "Restoring SMBIOS..."
    /usr/libexec/PlistBuddy -c "Delete :SMBIOS" $EFIconfig
    /usr/libexec/PlistBuddy -c "Add :SMBIOS dict" $EFIconfig
    ./tools/merge_plist.sh "SMBIOS" $BAKconfig $EFIconfig
    /usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName $product" $EFIconfig
    echo
    echo "Restoring theme..."
    theme=`/usr/libexec/PlistBuddy -c "Print :GUI:Theme" $BAKconfig`
    /usr/libexec/PlistBuddy -c "Set :GUI:Theme $theme" $EFIconfig
fi

echo
echo Done!
