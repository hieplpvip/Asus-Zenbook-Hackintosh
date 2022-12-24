#!/bin/bash

oc_version="0.8.3"

curl_options="--retry 5 --location --progress-bar"
curl_options_silent="--retry 5 --location --silent"

# download latest release from github
function download_github()
# $1 is sub URL of release page
# $2 is partial file name to look for
# $3 is file name to rename to
{
    echo "downloading `basename $3 .zip`:"
	local jsonink="https://api.github.com/repos/$1/releases/latest"
    curl $curl_options_silent --output /tmp/com.hieplpvip.download.txt "$jsonink"
    local url=`grep "browser_download_url" /tmp/com.hieplpvip.download.txt | cut -d : -f 2,3 | tr -d \"|grep RELEASE`
    echo $url
    wget -O $3 $url
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


rm -rf download && mkdir ./download
cd ./download

# download resources FOR OpenCanopy (Themes)
mkdir ./resources && cd ./resources
download_raw https://github.com/acidanthera/OcBinaryData/archive/refs/heads/master.zip OcBinaryData.zip


echo "unzipping resources"
unzip -q OcBinaryData.zip 'OcBinaryData-master/Resources/**/*' -d "" 
cd ..

# download OpenCore
mkdir ./oc && cd ./oc
download_github "acidanthera/OpenCorePkg" "$oc_version-RELEASE" "OpenCore.zip"
unzip -o -q -d OpenCorePkg OpenCore.zip 
cd ..

# download kexts
mkdir ./zips && cd ./zips
download_github "acidanthera/Lilu" "RELEASE" "acidanthera-Lilu.zip"
download_github "acidanthera/AppleALC" "RELEASE" "acidanthera-AppleALC.zip"
download_github "acidanthera/AirportBrcmFixup" "RELEASE" "acidanthera-AirportBrcmFixup.zip"
download_github "acidanthera/BrcmPatchRAM" "RELEASE" "acidanthera-BrcmPatchRAM.zip"
download_github "acidanthera/CPUFriend" "RELEASE" "acidanthera-CPUFriend.zip"
download_github "acidanthera/CpuTscSync" "RELEASE" "acidanthera-CpuTscSync.zip"
download_github "acidanthera/HibernationFixup" "RELEASE" "acidanthera-HibernationFixup.zip"
download_github "acidanthera/VirtualSMC" "RELEASE" "acidanthera-VirtualSMC.zip"
download_github "acidanthera/VoodooPS2" "RELEASE" "acidanthera-VoodooPS2.zip"
download_github "acidanthera/WhateverGreen" "RELEASE" "acidanthera-WhateverGreen.zip"
download_github "hieplpvip/AsusSMC" "RELEASE" "hieplpvip-AsusSMC.zip"
#download_github "hieplpvip/AppleBacklightSmoother" "RELEASE" "hieplpvip-AppleBacklightSmoother.zip"
download_github "VoodooI2C/VoodooI2C" "VoodooI2C-" "VoodooI2C-VoodooI2C.zip"
cd ..

# download drivers
mkdir ./drivers && cd ./drivers
download_raw https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi HfsPlus.efi
cd ..


KEXTS="AppleALC|AppleBacklightSmoother|AsusSMC|BrcmPatchRAM3|BrcmFirmwareData|BlueToolFixup|WhateverGreen|CPUFriend|CPUFriendDataProvider|Lilu|VirtualSMC|SMCBatteryManager|SMCProcessor|VoodooI2C.kext|VoodooI2CHID.kext|VoodooPS2Controller|CpuTscSync|AirportBrcmFixup|HibernationFixup"

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
            if [[ "`echo $kextname | grep -w -E $KEXTS`" != "" ]]; then
                cp -R $kext ../kexts
            fi
        done
    fi
    check_directory $out/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/*.kext; do
            kextname="`basename $kext`"
            if [[ "`echo $kextname | grep -w -E $KEXTS`" != "" ]]; then
                cp -R $kext ../kexts
            fi
        done
    fi
    check_directory $out/Kexts/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/Kexts/*.kext; do
            kextname="`basename $kext`"
            if [[ "`echo $kextname | grep -w -E $KEXTS`" != "" ]]; then
                cp -R $kext ../kexts
            fi
        done
    fi
}

mkdir ./kexts

check_directory ./zips/*.zip
if [ $? -ne 0 ]; then
    echo Unzipping kexts...
    cd ./zips
    for kext in *.zip; do
        unzip_kext $kext
    done

    cd ..
fi

cd ..
