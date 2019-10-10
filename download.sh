#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root in order to overwrite old downloaded files (if exist)!"
    sudo $0 $@
    exit 0
fi

curl_options="--retry 5 --location --progress-bar"
curl_options_silent="--retry 5 --location --silent"

# download typical release from RehabMan bitbucket downloads
function download_RHM()
# $1 is subdir on rehabman bitbucket
# $2 is prefix of zip file name
{
    echo "downloading $2:"
    curl $curl_options_silent --output /tmp/com.hieplpvip.download.txt https://bitbucket.org/RehabMan/$1/downloads/
    local url=https://bitbucket.org`grep -o -m 1 "/RehabMan/$1/downloads/$2.*\.zip" /tmp/com.hieplpvip.download.txt|perl -ne 'print $1 if /(.*)\"/'`
    echo $url
    curl $curl_options --output "$2.zip" "$url"
    rm /tmp/com.hieplpvip.download.txt
    echo
}

# download latest release from github
function download_github()
# $1 is sub URL of release page
# $2 is partial file name to look for
# $3 is file name to rename to
{
    echo "downloading `basename $3 .zip`:"
    curl $curl_options_silent --output /tmp/com.hieplpvip.download.txt "https://github.com/$1"
    local url=https://github.com`grep -o -m 1 "/.*$2.*\.zip" /tmp/com.hieplpvip.download.txt`
    echo $url
    curl $curl_options --output "$3" "$url"
    rm /tmp/com.hieplpvip.download.txt
    echo
}

function download_raw()
{
    echo "downloading $2"
    echo $1
    curl $curl_options --output "$2" "$1"
    echo
}

PS3='Do you want to download NullEthernet?'$'\n''Yes if you''re using USB wifi adapter'$'\n''No if you have replaced your wifi card with a compatible one: '
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            nullethernet=1
            break;;
        "No")
            nullethernet=0
            break;;
        *) echo "Invalid";;
    esac
done
echo

if [ ! -d ./downloads ]; then mkdir ./downloads; fi
cd ./downloads
sudo rm -rf ./zips
sudo rm -rf ./required_le_kexts
sudo rm -rf ./le_kexts
sudo rm -rf ./clover_kexts
sudo rm -rf ./tools
sudo rm -rf ./drivers

# download kexts
mkdir ./zips && cd ./zips
download_github "acidanthera/Lilu/releases" "RELEASE" "acidanthera-Lilu.zip"
download_github "acidanthera/AppleALC/releases" "RELEASE" "acidanthera-AppleALC.zip"
download_github "acidanthera/AirportBrcmFixup/releases" "RELEASE" "acidanthera-AirportBrcmFixup.zip"
download_github "acidanthera/BT4LEContinuityFixup/releases" "RELEASE" "acidanthera-BT4LEContinuityFixup.zip"
download_github "acidanthera/VirtualSMC/releases" "RELEASE" "acidanthera-VirtualSMC.zip"
download_github "acidanthera/VoodooPS2/releases" "RELEASE" "acidanthera-VoodooPS2.zip"
download_github "acidanthera/WhateverGreen/releases" "RELEASE" "acidanthera-WhateverGreen.zip"
download_github "hieplpvip/AsusSMC/releases" "RELEASE" "hieplpvip-AsusSMC.zip"
download_github "alexandred/VoodooI2C/releases" "VoodooI2C-" "alexandred-VoodooI2C.zip"
download_github "PMheart/LiluFriend/releases" "RELEASE" "PMheart-LiluFriend.zip"
download_github "headkaze/OS-X-BrcmPatchRAM/releases" "BrcmPatchRAM" "headkaze-BrcmPatchRAM.zip"
download_RHM os-x-eapd-codec-commander RehabMan-CodecCommander
download_RHM os-x-acpi-poller RehabMan-Poller
download_RHM voodootscsync RehabMan-VoodooTSCSync
if [ $nullethernet -eq 1 ]; then
    download_RHM os-x-null-ethernet RehabMan-NullEthernet
fi

cd ..

# download tools
mkdir ./tools && cd ./tools
download_RHM os-x-maciasl-patchmatic RehabMan-patchmatic
download_RHM os-x-maciasl-patchmatic RehabMan-MaciASL
download_RHM acpica iasl
download_raw https://raw.githubusercontent.com/black-dragon74/OSX-Debug/master/IORegistryExplorer.zip IORegistryExplorer.zip
cd ..

REQUIREDLEKEXTS="CodecCommander"
LEKEXTS="ACPIPoller|AppleALC|AsusSMC|BrcmPatchRAM2|BrcmFirmwareData|WhateverGreen|Lilu|NullEthernet.kext|VirtualSMC|SMCBatteryManager|SMCProcessor|VoodooI2C.kext|VoodooI2CHID.kext|VoodooPS2Controller|VoodooTSCSync|Fixup"
CLOVERKEXTS="ACPIPoller|AppleALC|AsusSMC|BrcmPatchRAM2|BrcmFirmwareData|WhateverGreen|Lilu|NullEthernet.kext|VirtualSMC|SMCBatteryManager|SMCProcessor|VoodooI2C.kext|VoodooI2CHID.kext|VoodooPS2Controller|VoodooTSCSync|Fixup"

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

function unzip_kext
{
    out=${1/.zip/}
    rm -Rf $out/* && unzip -q -d $out $1
    check_directory $out/Release/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/Release/*.kext; do
            kextname="`basename $kext`"
            if [[ "`echo $kextname | grep -E $REQUIREDLEKEXTS`" != "" ]]; then
                cp -R $kext ../required_le_kexts
            fi
            if [[ "`echo $kextname | grep -E $LEKEXTS`" != "" ]]; then
                cp -R $kext ../le_kexts
            fi
            if [[ "`echo $kextname | grep -E $CLOVERKEXTS`" != "" ]]; then
                cp -R $kext ../clover_kexts
            fi
        done
    fi
    check_directory $out/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/*.kext; do
            kextname="`basename $kext`"
            if [[ "`echo $kextname | grep -E $REQUIREDLEKEXTS`" != "" ]]; then
                cp -R $kext ../required_le_kexts
            fi
            if [[ "`echo $kextname | grep -E $LEKEXTS`" != "" ]]; then
                cp -R $kext ../le_kexts
            fi
            if [[ "`echo $kextname | grep -E $CLOVERKEXTS`" != "" ]]; then
                cp -R $kext ../clover_kexts
            fi
        done
    fi
    check_directory $out/Kexts/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/Kexts/*.kext; do
            kextname="`basename $kext`"
            if [[ "`echo $kextname | grep -E $REQUIREDLEKEXTS`" != "" ]]; then
                cp -R $kext ../required_le_kexts
            fi
            if [[ "`echo $kextname | grep -E $LEKEXTS`" != "" ]]; then
                cp -R $kext ../le_kexts
            fi
            if [[ "`echo $kextname | grep -E $CLOVERKEXTS`" != "" ]]; then
                cp -R $kext ../clover_kexts
            fi
        done
    fi
}

mkdir ./required_le_kexts
mkdir ./le_kexts
mkdir ./clover_kexts

check_directory ./zips/*.zip
if [ $? -ne 0 ]; then
    echo Unzipping kexts...
    cd ./zips
    for kext in *.zip; do
        unzip_kext $kext
    done

    cd ..
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:'ACPI Poller':IONameMatch FAN00000" le_kexts/ACPIPoller.kext/Contents/Info.plist
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:'ACPI Poller':Methods:0 FCPU" le_kexts/ACPIPoller.kext/Contents/Info.plist

    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:'ACPI Poller':IONameMatch FAN00000" clover_kexts/ACPIPoller.kext/Contents/Info.plist
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:'ACPI Poller':Methods:0 FCPU" clover_kexts/ACPIPoller.kext/Contents/Info.plist

    for thefile in $( find le_kexts \( -type f -name Info.plist -not -path '*/Lilu.kext/*' -not -path '*/LiluFriend.kext/*' -print0 \) | xargs -0 grep -l '<key>as.vit9696.Lilu</key>' ); do
        name="`/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' $thefile`"
        version="`/usr/libexec/PlistBuddy -c 'Print :OSBundleCompatibleVersion' $thefile`"
        if [[ -z "${version}" ]]; then
            version="`/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' $thefile`"
        fi
        /usr/libexec/PlistBuddy -c "Add :OSBundleLibraries:$name string $version" le_kexts/LiluFriend.kext/Contents/Info.plist
    done

    for thefile in $( find clover_kexts \( -type f -name Info.plist -not -path '*/Lilu.kext/*' -not -path '*/LiluFriend.kext/*' -print0 \) | xargs -0 grep -l '<key>as.vit9696.Lilu</key>' ); do
        name="`/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' $thefile`"
        version="`/usr/libexec/PlistBuddy -c 'Print :OSBundleCompatibleVersion' $thefile`"
        if [[ -z "${version}" ]]; then
            version="`/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' $thefile`"
        fi
        /usr/libexec/PlistBuddy -c "Add :OSBundleLibraries:$name string $version" clover_kexts/LiluFriend.kext/Contents/Info.plist
    done
fi

mkdir ./drivers
cp ./zips/acidanthera-VirtualSMC/Drivers/VirtualSmc.efi ./drivers

cd ..
