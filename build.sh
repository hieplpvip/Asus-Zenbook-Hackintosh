#!/bin/bash
IASL='./tools/iasl -vw 3073 -vi -vr -p'

# Select model
. ./src/models.txt
PS3='Select model: '
select opt in "${MODELS[@]}"
do
    for i in "${!MODELS[@]}"; do
        if [[ "${MODELS[$i]}" = "${opt}" ]]; then
            modelidx=$i
            break 2
        fi
    done
    echo Invalid
    echo
done
echo

# Load model config
. ./src/models/"${MODELCONFIG[$modelidx]}"

rm -rf build && mkdir build

# Copy OpenCore EFI folder
cp -R download/oc/OpenCorePkg/X64/EFI build

OCFOLDER="build/EFI/OC"

# Build ACPI
for j in "${!AMLFILES[@]}"; do
    $IASL $OCFOLDER/ACPI/"${AMLFILES[$j]}".aml src/acpi/"${AMLFILES[$j]}".dsl
done

# Copy UEFI Drivers
cp -R download/drivers/* $OCFOLDER/Drivers/


# Copy kexts
cp -R download/kexts/* $OCFOLDER/Kexts/
cp -R src/kexts/* $OCFOLDER/Kexts/

# Copy Resources
cp -R download/resources/OcBinaryData-master/Resources/* $OCFOLDER/Resources/

# Copy OpenCore config
cp src/config/$CONFIGPLIST $OCFOLDER/config.plist

# Replace SMBIOS
if [ -e src/smbios.txt ]; then
    . src/smbios.txt
else
    . src/smbios-sample.txt
fi
sed -i "" -e "s/MLB_PLACEHOLDER/$MLB/" \
          -e "s/Serial_PLACEHOLDER/$SystemSerialNumber/" \
          -e "s/SmUUID_PLACEHOLDER/$SystemUUID/" $OCFOLDER/config.plist

# Remove unused UEFI Drivers
find $OCFOLDER/Drivers ! -name OpenCanopy.efi \
                       ! -name HfsPlus.efi \
                       ! -name OpenRuntime.efi -type f -delete

# Remove unused UEFI Tools
rm -rf $OCFOLDER/Tools
