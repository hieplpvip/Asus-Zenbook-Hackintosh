#!/bin/bash

#set -x

PS3='Select model: '
options=("UX410 (KabyLake)" "UX430 (KabyLake)")
select opt in "${options[@]}"
do
    case $opt in
        "UX410 (KabyLake)")
            $model=ux410_kaby
            break;;
        "UX430 (KabyLake)")
            $model=ux430_kaby
            break;;
        *) echo "Invalid";;
    esac
done
echo

PS3='Select CPU fan mode: '
options=("READ" "MOD")
select opt in "${options[@]}"
do
    case $opt in
        "READ")
            FANPREF=READ
            break;;
        "UX430 (KabyLake)")
            FANPREF=MOD
            break;;
        *) echo "Invalid";;
    esac
done
echo

EFIDIR=`./mount_efi.sh`
BUILDDIR=./build
ACPIPATCHED=$EFIDIR/EFI/CLOVER/ACPI/patched

case "$model" in
# model specific scripts
    ux410_kaby)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/ux410-kabylake/SSDT-UX410-KABYLAKE.aml $ACPIPATCHED
        cp $BUILDDIR/ux410-kabylake/SSDT-IGPU.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;
    ux430_kaby)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/ux430-kabylake/SSDT-UX430-KABYLAKE.aml $ACPIPATCHED
        cp $BUILDDIR/ux430-kabylake/SSDT-IGPU.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;
esac

