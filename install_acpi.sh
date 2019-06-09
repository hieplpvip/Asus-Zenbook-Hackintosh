#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

. ./src/config.txt

echo -e "\033[7mACPI PATCHES\033[0m"
echo

if [[ "$#" -lt 1 || $1 -lt 0 || $1 -ge  ${#MODELS[*]} ]]; then
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

#if [[ "$2" == "0" ]]; then
#    FANPREF=READ
#elif [[ "$2" == "1" ]]; then
#    FANPREF=MOD
#else
#    PS3='READ: allows apps like HWMonitor and iStat Menus to read CPU Fan Speed'$'\n''MOD: READ + custom fan control (quietest yet coolest)'$'\n''Select CPU Fan mode: '
#    options=("READ" "MOD")
#    select opt in "${options[@]}"
#    do
#        case $opt in
#            "READ")
#                FANPREF=READ
#                break;;
#            "MOD")
#                FANPREF=MOD
#                break;;
#            *)
#                echo Invalid
#                echo;;
#        esac
#    done
#    echo
#fi
FANPREF=MOD

EFI=`./mount_efi.sh`
ACPIPATCHED=$EFI/EFI/CLOVER/ACPI/patched

BAKDIR=$EFI/$ACPIBAK
if [ ! -d $BAKDIR ]; then mkdir $BAKDIR; fi

BAKPATCHED=$BAKDIR/`date +%Y%m%d%H%M%S`
if [ -d $ACPIPATCHED ]; then
    echo Backing up patched ACPI...
    mv $ACPIPATCHED $BAKPATCHED
fi

mkdir -p $ACPIPATCHED
cp $BUILDACPI/SSDT-FAN-$FANPREF.aml $ACPIPATCHED

echo "Installing ACPI for $NAME..."
echo

for aml in $BUILDACPI/$AMLDIR/*.aml; do
    cp $aml $ACPIPATCHED
done
ls $ACPIPATCHED

echo -e "\033[7m"
echo "------------------------------------------------------------"
echo "|           ASUS ZENBOOK HACKINTOSH by hieplpvip           |"
echo "|  A great amount of effort has been put in this project.  |"
echo "|     Please consider donating me at paypal.me/lebhiep     |"
echo "------------------------------------------------------------"
echo -e "\033[0m"
