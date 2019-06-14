#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

. ./src/config.txt

echo -e "\033[7mTOOLS/KEXTS\033[0m"
echo

TAG=tag_file
TAGCMD=`pwd`/tools/tag
SLE=/System/Library/Extensions
LE=/Library/Extensions

OLDKEXTS="ACPIBatteryManager|ACPIPoller|AppleALC|aDummyHDA|cloverHDA|AppleBacklightInjector|IntelBacklight|Asus|BrcmPatchRAM2|BrcmFirmware|CodecCommander|FakePCIID|FakeSMC|VirtualSMC|SMCBatteryManager|SMCLightSensor|SMCProcessor|SMCSuperIO|WhateverGreen|Shiki|Lilu|NullEthernet|USBInjectAll|Voodoo|Injector|Fixup"

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
        sudo "$TAGCMD" "$@"
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
        echo -e '\t'`basename $1`
        sudo rm -Rf $SLE/`basename $1` $KEXTDEST/`basename $1`
        sudo cp -Rf $1 $KEXTDEST
        $TAG -a Gray $KEXTDEST/`basename $1`
    fi
}

function install_app
{
    if [ "$1" != "" ]; then
        echo -e '\t'`basename $1`' to /Applications'
        sudo rm -Rf /Applications/`basename $1`
        sudo cp -Rf $1 /Applications
        $TAG -a Gray /Applications/`basename $1`
    fi
}

function install_binary
{
    if [ "$1" != "" ]; then
        echo -e '\t'`basename $1`' to /usr/bin'
        sudo rm -f /usr/bin/`basename $1`
        sudo cp -f $1 /usr/bin
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

PS3='Do you want to install tools: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            installtools=1
            break;;
        "No")
            installtools=0
            break;;
        *)
            echo Invalid
    esac
done
echo

#PS3='Do you want to install kexts to '$KEXTDEST': '
#options=("Yes" "No")
#select opt in "${options[@]}"
#do
#    case $opt in
#        "Yes")
#            # install kexts
#            check_directory ./downloads/le_kexts/*.kext
#            if [ $? -ne 0 ]; then
#                echo 'Installing kexts to '$KEXTDEST'...'
#                cd ./downloads/le_kexts
#                for kext in *.kext; do
#                    install_kext $kext
#                done
#                echo
#                cd ../..
#            fi
#
#            break;;
#        "No")
#            echo
#            break;;
#        *) echo "Invalid";;
#    esac
#done

PS3='Do you want to use custom power management via X86PlatformPluginInjector.kext: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            installx86=1
            break;;
        "No")
            installx86=0
            break;;
        *) echo "Invalid";;
    esac
done
echo

# install tool
if [ $installtools -eq 1 ]; then
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
fi

# remove old kexts in /L/E, /S/L/E
echo Removing old kexts in /L/E, /S/L/E
for kext in $LE/*.kext; do
    kextname="`basename $kext`"
    if [[ "`echo $kextname | grep -E $OLDKEXTS`" != "" ]]; then
        sudo rm -Rf $kext
    fi
done
for kext in $SLE/*.kext; do
    kextname="`basename $kext`"
    if [[ "`echo $kextname | grep -E $OLDKEXTS`" != "" ]]; then
        sudo rm -Rf $kext
    fi
done
echo

# install X86PlatformPluginInjector.kext
if [ $installx86 -eq 1 ]; then
    check_directory ./src/kexts/X86PlatformPluginInjector.kext
    if [ $? -ne 0 ]; then
        echo 'Installing X86PlatformPluginInjector.kext to '$KEXTDEST'...'
        install_kext ./src/kexts/X86PlatformPluginInjector.kext
    else
        echo 'X86PlatformPluginInjector.kext not found.'
        echo 'Please re-download this repo.'
    fi
    echo
fi

# install Bluetooth kexts to /L/E. these kexts dont work if injected by Clover
check_directory ./downloads/necessary_le_kexts/*.kext
if [ $? -ne 0 ]; then
    echo 'Installing necessary kexts to '$KEXTDEST'... These kexts won'"'"'t work if injected by Clover'
    cd ./downloads/necessary_le_kexts
    for kext in *.kext; do
        install_kext $kext
    done
    echo
    cd ../..
fi

# force cache rebuild with output
echo Rebuilding kextcache...
sudo kextcache -i /
echo

# install/update kexts on EFI/Clover/kexts/Other
EFI=`./mount_efi.sh`
CLOVERKEXTS=$EFI/EFI/CLOVER/kexts
BAKDIR=$EFI/$KEXTSBAK
if [ ! -d $BAKDIR ]; then mkdir $BAKDIR; fi

BAKKEXTS=$BAKDIR/`date +%Y%m%d%H%M%S`
if [ -d $CLOVERKEXTS ]; then
    echo Backing up kexts in Clover...
    mv $CLOVERKEXTS $BAKKEXTS
fi

echo Installing kexts to EFI/Clover/kexts/Other...
mkdir -p $CLOVERKEXTS/Other
cd ./downloads/clover_kexts
for kext in *.kext; do
    echo -e '\t'$kext
    cp -Rf $kext $CLOVERKEXTS/Other
done
echo
cd ../..

echo Installing AsusSMCDaemon...
./downloads/zips/hieplpvip-AsusSMC/install_daemon.sh
echo

echo Installing VirtualSmc.efi
cp -f ./downloads/drivers/VirtualSmc.efi $EFI/EFI/CLOVER/drivers64UEFI
rm -f $EFI/EFI/CLOVER/drivers64UEFI/SMCHelper.efi
rm -f $EFI/EFI/CLOVER/drivers64UEFI/SMCHelper-64.efi
echo

if [[ "$ALCPLUGFIX" != "" ]]; then
    echo Installing ALCPlugFix...
    cd ./src/alcplugfix/$ALCPLUGFIX
    sudo ./install.sh
    cd ../..
    echo
else
    sudo ./src/alcplugfix/uninstall.sh
fi

echo -e "\033[7m------------------------------------------------------------"
echo "|           ASUS ZENBOOK HACKINTOSH by hieplpvip           |"
echo "|  A great amount of effort has been put in this project.  |"
echo "|     Please consider donating me at paypal.me/lebhiep     |"
echo "------------------------------------------------------------"
echo -e "\033[0m"
