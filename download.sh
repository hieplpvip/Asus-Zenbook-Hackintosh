#!/bin/bash

#set -x

curl_options="--retry 5 --location --progress-bar"
curl_options_silent="--retry 5 --location --silent"

# download typical release from RehabMan bitbucket downloads
function download()
# $1 is subdir on rehabman bitbucket
# $2 is prefix of zip file name
{
    echo "downloading $2:"
    curl $curl_options_silent --output /tmp/org.rehabman.download.txt https://bitbucket.org/RehabMan/$1/downloads/
    local scrape=`grep -o -m 1 "/RehabMan/$1/downloads/$2.*\.zip" /tmp/org.rehabman.download.txt|perl -ne 'print $1 if /(.*)\"/'`
    local url=https://bitbucket.org$scrape
    echo $url
    if [ "$3" == "" ]; then
        curl $curl_options --remote-name "$url"
    else
        curl $curl_options --output "$3" "$url"
    fi
    rm /tmp/org.rehabman.download.txt
    echo
}

# download latest release from github (perhaps others)
function download_latest_notbitbucket()
# $1 is main URL
# $2 is URL of release page
# $3 is partial file name to look for
# $4 is file name to rename to
{
    echo "downloading latest $4 from $2:"
    curl $curl_options_silent --output /tmp/org.rehabman.download.txt "$2"
    local scrape=`grep -o -m 1 "/.*$3.*\.zip" /tmp/org.rehabman.download.txt`
    local url=$1$scrape
    echo $url
    curl $curl_options --output "$4" "$url"
    rm /tmp/org.rehabman.download.txt
    echo
}

function download_raw()
{
    echo "downloading $2"
    echo $1
    curl $curl_options --output "$2" "$1"
    echo
}

PS3='Which version of VoodooI2C do you want to use: '
options=("alexandred" "hieplpvip (better multitouch)")
select opt in "${options[@]}"
do
    case $opt in
        "alexandred")
            i2c=0
            break;;
        "hieplpvip (better multitouch)")
            i2c=1
            break;;
        *) echo "Invalid";;
    esac
done

if [ ! -d ./downloads ]; then mkdir ./downloads; fi && rm -Rf downloads/* && cd ./downloads

# download kexts
mkdir ./kexts && cd ./kexts
download os-x-fakesmc-kozlek RehabMan-FakeSMC
#download os-x-voodoo-ps2-controller RehabMan-Voodoo
download os-x-acpi-battery-driver RehabMan-Battery
download os-x-null-ethernet RehabMan-NullEthernet
download os-x-fake-pci-id RehabMan-FakePCIID
download os-x-brcmpatchram RehabMan-BrcmPatchRAM
download os-x-acpi-poller RehabMan-Poller
download os-x-usb-inject-all RehabMan-USBInjectAll
#download os-x-acpi-debug RehabMan-Debug
download_latest_notbitbucket "https://github.com" "https://github.com/acidanthera/Lilu/releases" "RELEASE" "nbb_acidanthera-Lilu.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/acidanthera/AppleALC/releases" "RELEASE" "nbb_acidanthera-AppleALC.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/acidanthera/WhateverGreen/releases" "RELEASE" "nbb_acidanthera-WhateverGreen.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/PMheart/LiluFriend/releases" "RELEASE" "nbb_PMheart-LiluFriend.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/lvs1974/AirportBrcmFixup/releases" "RELEASE" "nbb_lvs1974-AirportBrcmFixup.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/lvs1974/BT4LEContiunityFixup/releases" "Release_" "nbb_lvs1974-BT4LEContiunityFixup.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/hieplpvip/AppleBacklightFixup/releases" "AppleBacklightFixup-" "nbb_hieplpvip-AppleBacklightFixup.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/hieplpvip/AsusFnKeys/releases" "AsusFnKeys-UX410-" "nbb_hieplpvip-AsusFnKeys.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/hieplpvip/OS-X-Voodoo-PS2-Controller/releases" "VoodooPS2-UX410-" "nbb_hieplpvip-VoodooPS2.zip"
if [ $i2c -eq 1 ]; then
    download_latest_notbitbucket "https://github.com" "https://github.com/hieplpvip/VoodooI2C/releases" "VoodooI2C-UX410-" "nbb_hieplpvip-VoodooI2C.zip"
else
    download_latest_notbitbucket "https://github.com" "https://github.com/alexandred/VoodooI2C/releases" "VoodooI2C-v" "nbb_alexandred-VoodooI2C.zip"
fi

cd ..

# download tools
mkdir ./tools && cd ./tools
download os-x-maciasl-patchmatic RehabMan-patchmatic
download os-x-maciasl-patchmatic RehabMan-MaciASL
download acpica iasl iasl.zip
download_raw https://raw.githubusercontent.com/black-dragon74/OSX-Debug/master/IORegistryExplorer.zip IORegistryExplorer.zip
cd ..

LEKEXTS="ACPIBatteryManager|ACPIPoller|AppleALC|AppleBacklightFixup|AsusFnKeys|AirportBrcmFixup|BrcmPatchRAM2|BrcmFirmwareRepo|BT4LEContiunityFixup|FakePCIID.kext|FakePCIID_Broadcom_WiFi|FakeSMC|WhateverGreen|Lilu|LiluFriend|NullEthernet.kext|USBInjectAll|VoodooI2C.kext|VoodooI2CHID.kext|VoodooPS2Controller"
CLOVERKEXTS="ACPIBatteryManager|AppleALC|AppleBacklightFixup|AsusFnKeys|AirportBrcmFixup|BrcmPatchRAM2|BrcmFirmwareData|BT4LEContiunityFixup|FakePCIID.kext|FakePCIID_Broadcom_WiFi|FakeSMC.kext|WhateverGreen|Lilu|LiluFriend|NullEthernet.kext|USBInjectAll|VoodooI2C.kext|VoodooI2CHID.kext|VoodooPS2Controller"

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
            # install the kext when it exists regardless of filter
            kextname="`basename $kext`"
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
            # install the kext when it exists regardless of filter
            kextname="`basename $kext`"
            if [[ "`echo $kextname | grep -E $LEKEXTS`" != "" ]]; then
                cp -R $kext ../le_kexts
            fi
            if [[ "`echo $kextname | grep -E $CLOVERKEXTS`" != "" ]]; then
                cp -R $kext ../clover_kexts
            fi
        done
    fi
}

rm -rf ./le_kexts
rm -rf ./clover_kexts
mkdir ./le_kexts
mkdir ./clover_kexts

check_directory ./kexts/*.zip
if [ $? -ne 0 ]; then
    echo Unzipping kexts...
    cd ./kexts
    for kext in *.zip; do
        if [[ "`echo $kext | grep FakeSMC`" != "" ]]; then
            cp -R $kext ../tools
        fi
        unzip_kext $kext
    done

    cd ..
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:'ACPI Poller':IONameMatch FAN00000" le_kexts/ACPIPoller.kext/Contents/Info.plist
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:'ACPI Poller':Methods:0 FCPU" le_kexts/ACPIPoller.kext/Contents/Info.plist

    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:FakeSMC:Configuration:smc-compatible smc-huronriver" le_kexts/FakeSMC.kext/Contents/Info.plist
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:FakeSMC:Configuration:smc-compatible smc-huronriver" clover_kexts/FakeSMC.kext/Contents/Info.plist

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
    cd ..
fi
