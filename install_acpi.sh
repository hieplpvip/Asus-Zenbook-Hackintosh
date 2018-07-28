#!/bin/bash

#set -x

if [[ "$1" == "" ]]; then
    echo "Usage: ./install_acpi.sh [model] [fanpref]"
    echo "Use ./install_acpi.sh help for a listing of supported models."
    echo "fanpref is default to READ (other: MOD)"
exit
fi

if [[ "$1" == "help" ]]; then
    grep -o install_.*\) $0 | grep -v grep | tr ')' ' '
    exit
fi

EFIDIR=`./mount_efi.sh`
BUILDDIR=./build
ACPIPATCHED=$EFIDIR/EFI/CLOVER/ACPI/patched

if [[ "$2" != "" ]]; then
    FANPREF=$2
else
    FANPREF=READ
fi

case "$1" in
# model specific scripts
    install_ux410)
        rm -f $ACPIPATCHED/DSDT.aml
        rm -f $ACPIPATCHED/SSDT-*.aml
        cp $BUILDDIR/SSDT-UX410-KABYLAKE.aml $ACPIPATCHED
        cp $BUILDDIR/SSDT-FAN-$FANPREF.aml $ACPIPATCHED
        ls $ACPIPATCHED
    ;;

# unknown models
    *)
        echo "Error: Unknown model, \"$1\", specifed."
    ;;
esac

