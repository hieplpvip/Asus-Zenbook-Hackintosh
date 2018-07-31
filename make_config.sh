#!/bin/bash

PS3='Which filesystem are you using: '
options=("APFS" "HFS+")
select opt in "${options[@]}"
do
    case $opt in
        "APFS")
            apfs=1
            break;;
        "HFS+")
            apfs=0
            break;;
        *) echo "Invalid";;
    esac
done
echo

function disableTRIM()
# $1 is path to config.plist
{
    plistFile=$1
    if [ $apfs -eq 1 ]; then
        cnt=`/usr/libexec/PlistBuddy -c "Print :KernelAndKextPatches:KextsToPatch" $plistFile | grep "Dict" | wc -w`
        cnt=`expr $cnt - 1`

        for idx in `seq 0 $cnt`
        do
            val=`/usr/libexec/PlistBuddy -c "Print :KernelAndKextPatches:KextsToPatch:$idx:Name" $plistFile`
            if [ $val = 'com.apple.iokit.IOAHCIBlockStorage' ]; then
                /usr/libexec/PlistBuddy -c "Add :KernelAndKextPatches:KextsToPatch:$idx:Disabled bool YES" $plistFile
            fi
        done
    fi
}

printf "!! creating config/config_ux410_kabylake.plist\n"
cp config_parts/config_master.plist config/config_ux410_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" config/config_ux410_kabylake.plist
./merge_plist.sh "KernelAndKextPatches" config_parts/config_KabyLake.plist config/config_ux410_kabylake.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_KabyLake_hdmi_audio.plist config/config_ux410_kabylake.plist
disableTRIM config/config_ux410_kabylake.plist
printf "\n"

printf "!! creating config/config_ux430_kabylake.plist\n"
cp config_parts/config_master.plist config/config_ux430_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" config/config_ux430_kabylake.plist
./merge_plist.sh "KernelAndKextPatches" config_parts/config_KabyLake.plist config/config_ux430_kabylake.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_KabyLake_hdmi_audio.plist config/config_ux430_kabylake.plist
disableTRIM config/config_ux430_kabylake.plist
printf "\n"

printf "!! creating config/config_ux430_kabylaker.plist\n"
cp config_parts/config_master.plist config/config_ux430_kabylaker.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro15,2" config/config_ux430_kabylaker.plist
./merge_plist.sh "KernelAndKextPatches" config_parts/config_KabyLake.plist config/config_ux430_kabylaker.plist
#./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_KabyLake_hdmi_audio.plist config/config_ux430_kabylaker.plist
disableTRIM config/config_ux430_kabylaker.plist
printf "\n"
