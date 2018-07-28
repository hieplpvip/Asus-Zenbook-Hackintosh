#!/bin/bash

#set -x

SUDO=sudo
#SUDO='echo #'
#SUDO=nothing
TAG=tag_file
TAGCMD=`pwd`/tools/tag
SLE=/System/Library/Extensions
LE=/Library/Extensions

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

function nothing
{
    :
}

function install_kext
{
    if [ "$1" != "" ]; then
        echo installing $1 to $KEXTDEST
        $SUDO rm -Rf $SLE/`basename $1` $KEXTDEST/`basename $1`
        $SUDO cp -Rf $1 $KEXTDEST
        $TAG -a Gray $KEXTDEST/`basename $1`
    fi
}

function install_app
{
    if [ "$1" != "" ]; then
        echo installing $1 to /Applications
        $SUDO rm -Rf /Applications/`basename $1`
        $SUDO cp -Rf $1 /Applications
        $TAG -a Gray /Applications/`basename $1`
    fi
}

function install_binary
{
    if [ "$1" != "" ]; then
        echo installing $1 to /usr/bin
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

if [ "$(id -u)" != "0" ]; then
    echo "This script requires superuser access..."
    exit 1
fi

# unzip/install tools
check_directory ./downloads/tools/*.zip
if [ $? -ne 0 ]; then
    echo Installing tools...
    cd ./downloads/tools
    for tool in *.zip; do
        install $tool
    done
    echo
    cd ../..
fi

if [ "$1" != "toolsonly" ]; then

# unzip/install kexts
check_directory ./downloads/le_kexts/*.kext
if [ $? -ne 0 ]; then
    echo Installing kexts...
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

# install/update kexts on EFI/Clover/kexts/Other
EFI=`./mount_efi.sh`
echo Installing kexts to EFI/Clover/kexts/Other
rm -Rf $EFI/EFI/CLOVER/kexts/Other/*.kext
cd ./downloads/clover_kexts
for kext in *.kext; do
    echo installing $kext
    cp -Rf $kext $EFI/EFI/CLOVER/kexts/Other
done
echo
cd ../..

fi # "toolsonly"

echo Done. Enjoy!
