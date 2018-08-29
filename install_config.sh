#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

. ./src/config.txt

PS3='Select model: '
options=("UX310 (KabyLake)" "UX410 (KabyLake)" "UX430 (KabyLake)" "UX430 (KabyLake-R)")
select opt in "${options[@]}"
do
    case $opt in
        "UX310 (KabyLake)")
            config=$BUILDCONFIG"/config_ux310_kabylake.plist"
            product="MacBookPro14,1"
            break;;
        "UX410 (KabyLake)")
            config=$BUILDCONFIG"/config_ux410_kabylake.plist"
            product="MacBookPro14,1"
            break;;
        "UX430 (KabyLake)")
            config=$BUILDCONFIG"/config_ux430_kabylake.plist"
            product="MacBookPro14,1"
            break;;
        "UX430 (KabyLake-R)")
            config=$BUILDCONFIG"/config_ux430_kabylaker.plist"
            product="MacBookPro14,1"
            break;;
        *) echo "Invalid";;
    esac
done
echo

echo Mounting EFI...
EFI=`./mount_efi.sh`
EFICONFIG=$EFI/EFI/CLOVER/config.plist
BAKDIR=$EFI/$CONFIGBAK
if [ ! -d $BAKDIR ]; then mkdir $BAKDIR; fi

BAKCONFIG=$BAKDIR/config_`date +%Y%m%d%H%M%S`.plist
if [ -f $EFICONFIG ]; then
    echo "Found config.plist in EFI. Backing up..."
    mv $EFICONFIG $BAKCONFIG
fi

cp $config $EFICONFIG
if [ -f $BAKCONFIG ]; then
    echo "Restoring SMBIOS..."
    /usr/libexec/PlistBuddy -c "Delete :SMBIOS" $EFICONFIG
    /usr/libexec/PlistBuddy -c "Add :SMBIOS dict" $EFICONFIG
    ./tools/merge_plist.sh "SMBIOS" $BAKCONFIG $EFICONFIG
    /usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName $product" $EFICONFIG
    echo
    echo "Restoring theme..."
    theme=`/usr/libexec/PlistBuddy -c "Print :GUI:Theme" $BAKCONFIG`
    /usr/libexec/PlistBuddy -c "Set :GUI:Theme $theme" $EFICONFIG
fi

echo
echo Done!
