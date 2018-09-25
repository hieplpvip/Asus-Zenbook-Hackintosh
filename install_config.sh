#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

. ./src/config.txt

if [[ "$#" -ne 1 || $1 -lt 0 || $1 -ge  ${#MODELS[*]} ]]; then
    PS3='Select model: '
    select opt in "${MODELS[@]}"
    do
        for i in "${!MODELS[@]}"; do
            if [[ "${MODELS[$i]}" = "${opt}" ]]; then
                idx=$i
                break 2
            fi
        done
        echo Invalid
        echo
    done
    echo
else
    idx=$1
fi

. ./src/models/"${MODELCONFIG[$idx]}"

echo Mounting EFI...
EFI=`./mount_efi.sh`
EFICONFIG=$EFI/EFI/CLOVER/config.plist
BAKDIR=$EFI/$CONFIGBAK
if [ ! -d $BAKDIR ]; then mkdir $BAKDIR; fi
echo

BAKCONFIG=$BAKDIR/config_`date +%Y%m%d%H%M%S`.plist
if [ -f $EFICONFIG ]; then
    echo "Found config.plist in EFI. Backing up..."
    mv $EFICONFIG $BAKCONFIG
fi

echo "Installing config.plist for $NAME..."
echo

cp $BUILDCONFIG/$CONFIGPLIST $EFICONFIG
if [ -f $BAKCONFIG ]; then
    echo "Restoring SMBIOS..."
    /usr/libexec/PlistBuddy -c "Delete :SMBIOS" $EFICONFIG
    /usr/libexec/PlistBuddy -c "Add :SMBIOS dict" $EFICONFIG
    ./tools/merge_plist.sh "SMBIOS" $BAKCONFIG $EFICONFIG
    /usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName $PRODUCTNAME" $EFICONFIG
    echo "Restoring theme..."
    theme=`/usr/libexec/PlistBuddy -c "Print :GUI:Theme" $BAKCONFIG`
    /usr/libexec/PlistBuddy -c "Set :GUI:Theme $theme" $EFICONFIG
fi
