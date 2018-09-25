#!/bin/bash

. ./src/config.txt

PS3='Which filesystem are you using: '
options=("APFS (TRIM will be disabled)" "HFS+ (TRIM will be enabled)")
select opt in "${options[@]}"
do
    case $opt in
        "APFS (TRIM will be disabled)")
            apfs=1
            break;;
        "HFS+ (TRIM will be enabled)")
            apfs=0
            break;;
        *) echo "Invalid";;
    esac
done
echo

#list="AE AF AR AT AU AZ BD BE BG BN BR BT BY CA CH CL CN CO CR CY CZ DE DK DO EC EE EG ES FI FR GB GR GT GU HK HN HR HU ID IE IL IN IS IT JM JO JP KH KR KZ LA LI LK LT LU LV MA MM MN MO MT MV MX MY NI NL NO NP NZ PA PE PH PK PL PR PT PY RO RS RU SA SE SG SI SK SV TH TR TT TW UA US UY VE VI VN ZA"
#while :
#do
#    read -p "Enter Wifi country code ('list' to see available codes): " country
#    if [[ $list =~ (^|[[:space:]])$country($|[[:space:]]) ]]; then
#        echo
#        break
#    elif [ $country = 'list' ]; then
#        echo $list
#    else
#        echo Invalid country code $country
#    fi
#    echo
#done

function countArray()
# $1 is path to config.plist
# $2 is path to array in plist
# result is in $cnt
{
    plistFile=$1
    cnt=0
    while true ; do
        /usr/libexec/PlistBuddy -c "Print :$2:$cnt" $plistFile >/dev/null 2>/dev/null
        if [ $? -ne 0 ]; then
            break
        fi
        cnt=$(($cnt + 1))
    done
}

function patchTRIM()
# $1 is path to config.plist
{
    plistFile=$1
    if [ $apfs -eq 1 ]; then
        countArray $plistFile "KernelAndKextPatches:KextsToPatch"
        cnt=$(($cnt - 1))

        for idx in `seq 0 $cnt`
        do
            val=`/usr/libexec/PlistBuddy -c "Print :KernelAndKextPatches:KextsToPatch:$idx:Name" $plistFile`
            if [ "$val" = "com.apple.iokit.IOAHCIBlockStorage" ]; then
                /usr/libexec/PlistBuddy -c "Add :KernelAndKextPatches:KextsToPatch:$idx:Disabled bool YES" $plistFile
            fi
        done
    fi
}

function patchCountryCode()
# $1 is path to config.plist
{
    plistFile=$1
    args=`/usr/libexec/PlistBuddy -c "Print :Boot:Arguments" $plistFile`' brcmfx-country='$country
    /usr/libexec/PlistBuddy -c "Set :Boot:Arguments $args" $plistFile
}

function enableI2CPatch()
# $1 is path to config.plist
{
    plistFile=$1
    countArray $plistFile "ACPI:DSDT:Patches"
    cnt=$(($cnt - 1))

    for idx in `seq 0 $cnt`
    do
        val=`/usr/libexec/PlistBuddy -c "Print :ACPI:DSDT:Patches:$idx:Comment" $plistFile`
        if [ "$val" = "change Method(_STA,0,NS) in GPI0 to XSTA" ]; then
            /usr/libexec/PlistBuddy -c "Delete :ACPI:DSDT:Patches:$idx:Disabled" $plistFile
        fi
        if [ "$val" = "change Method(_CRS,0,S) in ETPD to XCRS" ]; then
            /usr/libexec/PlistBuddy -c "Delete :ACPI:DSDT:Patches:$idx:Disabled" $plistFile
        fi
    done
}

if [ ! -d $BUILDDIR ]; then mkdir $BUILDDIR; fi
rm -rf $BUILDCONFIG
mkdir $BUILDCONFIG

echo creating config_ux303_broadwell.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux303_broadwell.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX303 (Broadwell)" $BUILDCONFIG/config_ux303_broadwell.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro12,1" $BUILDCONFIG/config_ux303_broadwell.plist
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_Broadwell.plist $BUILDCONFIG/config_ux303_broadwell.plist
patchTRIM $BUILDCONFIG/config_ux303_broadwell.plist
echo

echo creating config_ux310_kabylake.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux310_kabylake.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX310 (KabyLake)" $BUILDCONFIG/config_ux310_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" $BUILDCONFIG/config_ux310_kabylake.plist
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_KabyLake.plist $BUILDCONFIG/config_ux310_kabylake.plist
patchTRIM $BUILDCONFIG/config_ux310_kabylake.plist
echo

echo creating config_ux330_kabylake.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux330_kabylake.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX330 (KabyLake)" $BUILDCONFIG/config_ux330_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" $BUILDCONFIG/config_ux330_kabylake.plist
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_KabyLake.plist $BUILDCONFIG/config_ux330_kabylake.plist
patchTRIM $BUILDCONFIG/config_ux330_kabylake.plist
echo

echo creating config_ux330_kabylaker.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux330_kabylaker.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX330 (KabyLake-R)" $BUILDCONFIG/config_ux330_kabylaker.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" $BUILDCONFIG/config_ux330_kabylaker.plist
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_KabyLake.plist $BUILDCONFIG/config_ux330_kabylaker.plist
patchTRIM $BUILDCONFIG/config_ux330_kabylaker.plist
echo

echo creating config_ux410_kabylake.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux410_kabylake.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX410 (KabyLake)" $BUILDCONFIG/config_ux410_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" $BUILDCONFIG/config_ux410_kabylake.plist
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_KabyLake.plist $BUILDCONFIG/config_ux410_kabylake.plist
patchTRIM $BUILDCONFIG/config_ux410_kabylake.plist
echo

echo creating config_ux430_kabylake.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux430_kabylake.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX430 (KabyLake)" $BUILDCONFIG/config_ux430_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" $BUILDCONFIG/config_ux430_kabylake.plist
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_KabyLake.plist $BUILDCONFIG/config_ux430_kabylake.plist
patchTRIM $BUILDCONFIG/config_ux430_kabylake.plist
echo

echo creating config_ux430_kabylaker.plist
cp $SRCCONFIG/config_master.plist $BUILDCONFIG/config_ux430_kabylaker.plist
/usr/libexec/PlistBuddy -c "Add :Comment string This config is created by @hieplpvip for UX430 (KabyLake-R)" $BUILDCONFIG/config_ux430_kabylaker.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" $BUILDCONFIG/config_ux430_kabylaker.plist # use MacBookPro14,1 for now, as support for MacBookPro15,2 isn't officialy out
./tools/merge_plist.sh "KernelAndKextPatches" $SRCCONFIG/config_KabyLake.plist $BUILDCONFIG/config_ux430_kabylaker.plist
enableI2CPatch $BUILDCONFIG/config_ux430_kabylaker.plist
patchTRIM $BUILDCONFIG/config_ux430_kabylaker.plist
echo
