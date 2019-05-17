#!/bin/bash
IASL=./tools/iasl
. ./src/config.txt

if [ ! -d $BUILDDIR ]; then mkdir $BUILDDIR; fi
rm -rf $BUILDACPI
mkdir $BUILDACPI

$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-ELAN.aml $SRCHOTPATCH/SSDT-ELAN.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-I2CBUS.aml $SRCHOTPATCH/SSDT-I2CBUS.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-FAN-MOD.aml $SRCHOTPATCH/SSDT-FAN-MOD.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-FAN-READ.aml $SRCHOTPATCH/SSDT-FAN-READ.dsl

for i in "${!MODELCONFIG[@]}"; do
    . ./src/models/"${MODELCONFIG[$i]}"
    if [ ! -d ./$BUILDACPI/$AMLDIR ]; then mkdir ./$BUILDACPI/$AMLDIR; fi && rm -Rf $BUILDACPI/$AMLDIR/*
    for j in "${!AMLFILES[@]}"; do
        $IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/$AMLDIR/"${AMLFILES[$j]}".aml $SRCHOTPATCH/"${AMLFILES[$j]}".dsl
    done
done

#ux303 broadwell
if [ ! -d ./$BUILDACPI/ux303-broadwell ]; then mkdir ./$BUILDACPI/ux303-broadwell; fi && rm -Rf $BUILDACPI/ux303-broadwell/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux303-broadwell/SSDT-UX303-Broadwell.aml $SRCHOTPATCH/SSDT-UX303-Broadwell.dsl
