#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

SUDO=sudo
TAG=tag_file
TAGCMD=`pwd`/tools/tag
SLE=/System/Library/Extensions
LE=/Library/Extensions

OLDKEXTS="ACPIBatteryManager|ACPIPoller|AppleALC|aDummyHDA|Backlight|Asus|AirportBrcmFixup|BrcmPatchRAM2|BrcmFirmware|BT4LEContiunityFixup|FakePCIID|FakeSMC|WhateverGreen|IntelGraphicsFixup|NvidiaGraphicsFixup|CoreDisplayFixup|Shiki|Lilu|NullEthernet|USBInjectAll|VoodooI2C|VoodooPS2Controller"

# extract minor version (eg. 10.9 vs. 10.10 vs. 10.11)
MINOR_VER=$([[ "$(sw_vers -productVersion)" =~ [0-9]+\.([0-9]+) ]] && echo ${BASH_REMATCH[1]})

# install to /Library/Extensions for 10.11 or greater
if [[ $MINOR_VER -ge 11 ]]; then
    KEXTDEST=$LE
else
    KEXTDEST=$SLE
fi

# this could be removed if 'tag' can be made to work on old systems
function tag_file
{
    if [[ $MINOR_VER -ge 9 ]]; then
        $SUDO "$TAGCMD" "$@"
    fi
}

function check_directory
{
    for x in $1; do
        if [ -e "$x" ]; then
            return 1
        else
            return 0
        fi
    done
}

function install_kext
{
    if [ "$1" != "" ]; then
        echo -e '\t'$1
        $SUDO rm -Rf $SLE/`basename $1` $KEXTDEST/`basename $1`
        $SUDO cp -Rf $1 $KEXTDEST
        $TAG -a Gray $KEXTDEST/`basename $1`
    fi
}

function install_app
{
    if [ "$1" != "" ]; then
        echo -e '\t'$1' to /Applications'
        $SUDO rm -Rf /Applications/`basename $1`
        $SUDO cp -Rf $1 /Applications
        $TAG -a Gray /Applications/`basename $1`
    fi
}

function install_binary
{
    if [ "$1" != "" ]; then
        echo -e '\t'$1' to /usr/bin'
        $SUDO rm -f /usr/bin/`basename $1`
        $SUDO cp -f $1 /usr/bin
        $TAG -a Gray /usr/bin/`basename $1`
    fi
}

function install
{
    installed=0
    out=${1/.zip/}
    rm -Rf $out/* && unzip -q -d $out $1
    check_directory $out/Release/*.app
    if [ $? -ne 0 ]; then
        for app in $out/Release/*.app; do
            install_app $app
        done
        installed=1
    fi
    check_directory $out/*.app
    if [ $? -ne 0 ]; then
        for app in $out/*.app; do
            install_app $app
        done
        installed=1
    fi
    if [ $installed -eq 0 ]; then
        check_directory $out/*
        if [ $? -ne 0 ]; then
            for tool in $out/*; do
                install_binary $tool
            done
        fi
    fi
}

PS3='Do you want to install tools: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            # install tools
            check_directory ./downloads/tools/*.zip
            if [ $? -ne 0 ]; then
                echo Installing tools...
                cd ./downloads/tools
                for tool in *.zip; do
                    install $tool
                done
                cd ../..
            fi
            echo
            break;;
        "No")
            echo
            break;;
        *) echo "Invalid";;
    esac
done

PS3='Do you want to install kexts to '$KEXTDEST': '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            # remove old kexts
            for kext in $KEXTDEST/*.kext; do
                kextname="`basename $kext`"
                if [[ "`echo $kextname | grep -E $OLDKEXTS`" != "" ]]; then
                    rm -Rf $kext
                fi
            done
            # install kexts
            check_directory ./downloads/le_kexts/*.kext
            if [ $? -ne 0 ]; then
                echo 'Installing kexts to '$KEXTDEST'...'
                cd ./downloads/le_kexts
                for kext in *.kext; do
                    install_kext $kext
                done
                echo
                cd ../..
            fi

            # force cache rebuild with output
            echo Rebuilding kextcache...
            $SUDO kextcache -i /
            echo

            break;;
        "No")
            echo
            break;;
        *) echo "Invalid";;
    esac
done

# install/update kexts on EFI/Clover/kexts/Other
EFI=`./mount_efi.sh`
CLOVERKEXT=$EFI/EFI/CLOVER/kexts
BAKKEXT=$EFI/EFI/CLOVER/bak_kexts
if [ -d $CLOVERKEXT ]; then
    echo Backing up kexts in Clover...
    rm -rf $BAKKEXT
    mv $CLOVERKEXT $BAKKEXT
fi

echo Installing kexts to EFI/Clover/kexts/Other
mkdir -p $CLOVERKEXT/Other
#rm -Rf $EFI/EFI/CLOVER/kexts/Other/*.kext
cd ./downloads/clover_kexts
for kext in *.kext; do
    echo -e '\t'$kext
    cp -Rf $kext $CLOVERKEXT/Other
done
echo
cd ../..

echo Done. Enjoy!
