#!/bin/bash
printf "!! creating config/config_ux410_kabylake.plist\n"
cp config_parts/config_master.plist config/config_ux410_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" config/config_ux410_kabylake.plist
./merge_plist.sh "KernelAndKextPatches" config_parts/config_Kabylake.plist config/config_ux410_kabylake.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_Kabylake_hdmi_audio.plist config/config_ux410_kabylake.plist
printf "\n"
printf "!! creating config/config_ux430_kabylake.plist\n"
cp config_parts/config_master.plist config/config_ux430_kabylake.plist
/usr/libexec/PlistBuddy -c "Set :SMBIOS:ProductName MacBookPro14,1" config/config_ux430_kabylake.plist
./merge_plist.sh "KernelAndKextPatches" config_parts/config_Kabylake.plist config/config_ux430_kabylake.plist
./merge_plist.sh "KernelAndKextPatches:KextsToPatch" config_parts/config_Kabylake_hdmi_audio.plist config/config_ux430_kabylake.plist
printf "\n"
