#!/bin/bash

if [ "$(id -u)" != "0" ] && [ "$(sudo -n echo 'sudo' 2> /dev/null)" != "sudo" ]; then
    echo "This script must be run as root!"
    sudo $0 $@
    exit 0
fi

PS3='Select model: '
options=("UX310 (KabyLake)" "UX410 (KabyLake)" "UX430 (KabyLake)" "UX430 (KabyLake-R)")
select opt in "${options[@]}"
do
    case $opt in
        "UX310 (KabyLake)")
            model=ux310_kaby
            break;;
        "UX410 (KabyLake)")
            model=ux410_kaby
            break;;
        "UX430 (KabyLake)")
            model=ux430_kaby
            break;;
        "UX430 (KabyLake-R)")
            model=ux430_kabyr
            break;;
        *) echo "Invalid";;
    esac
done
echo

PS3='READ: allows apps like HWMonitor and iStat Menus to read CPU Fan Speed'$'\n''MOD: READ + custom fan control (quietest yet coolest)'$'\n''Select CPU Fan mode: '
options=("READ" "MOD")
select opt in "${options[@]}"
do
    case $opt in
        "READ")
            FANPREF=READ
            break;;
        "MOD")
            FANPREF=MOD
            break;;
        *) echo "Invalid";;
    esac
done
echo

EFI=`./mount_efi.sh`
BUILDDIR=./build
ACPIPATCHED=$EFI/EFI/CLOVER/ACPI/patched

BAKdir=$EFI/EFI/CLOVER/ACPI/patched_backup
if [ ! -d $BAKdir ]; then mkdir $BAKdir; fi

BAKPATCHED=$BAKdir/`date +%Y%m%d%H%M%S`
if [ -d $ACPIPATCHED ]; then
    echo Backing up patched ACPI...
    mv $ACPIPATCHED $BAKPATCHED
fi

mkdir -p $ACPIPATCHED

case "$model" in
# model specific scripts
    ux310_kaby)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/ux310-kabylake/SSDT-UX310-KabyLake.aml $ACPIPATCHED
#cp $BUILDDIR/ux310-kabylake/SSDT-IGPU.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;
    ux410_kaby)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/ux410-kabylake/SSDT-UX410-KabyLake.aml $ACPIPATCHED
#cp $BUILDDIR/ux410-kabylake/SSDT-IGPU.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;
    ux430_kaby)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/ux430-kabylake/SSDT-UX430-KabyLake.aml $ACPIPATCHED
#cp $BUILDDIR/ux430-kabylake/SSDT-IGPU.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;
    ux430_kabyr)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/ux430-kabylaker/SSDT-UX430-KabyLakeR.aml $ACPIPATCHED
        #cp $BUILDDIR/ux430-kabylaker/SSDT-ELAN.aml $ACPIPATCHED
#cp $BUILDDIR/ux430-kabylaker/SSDT-IGPU.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;
esac

