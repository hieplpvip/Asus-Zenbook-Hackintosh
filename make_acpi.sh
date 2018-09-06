#!/bin/bash
IASL=./tools/iasl
. ./src/config.txt

if [ ! -d $BUILDDIR ]; then mkdir $BUILDDIR; fi
rm -rf $BUILDACPI
mkdir $BUILDACPI

$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-ELAN.aml $SRCHOTPATCH/SSDT-ELAN.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-FAN-MOD.aml $SRCHOTPATCH/SSDT-FAN-MOD.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/SSDT-FAN-READ.aml $SRCHOTPATCH/SSDT-FAN-READ.dsl

#ux303 broadwell
if [ ! -d ./$BUILDACPI/ux303-broadwell ]; then mkdir ./$BUILDACPI/ux303-broadwell; fi && rm -Rf $BUILDACPI/ux303-broadwell/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux303-broadwell/SSDT-UX303-Broadwell.aml $SRCHOTPATCH/SSDT-UX303-Broadwell.dsl

#ux310 kabylake
if [ ! -d ./$BUILDACPI/ux310-kabylake ]; then mkdir ./$BUILDACPI/ux310-kabylake; fi && rm -Rf $BUILDACPI/ux310-kabylake/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux310-kabylake/SSDT-UX310-KabyLake.aml $SRCHOTPATCH/SSDT-UX310-KabyLake.dsl

#ux330 kabylaker
if [ ! -d ./$BUILDACPI/ux330-kabylaker ]; then mkdir ./$BUILDACPI/ux330-kabylaker; fi && rm -Rf $BUILDACPI/ux330-kabylaker/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux330-kabylaker/SSDT-UX330-KabyLakeR.aml $SRCHOTPATCH/SSDT-UX330-KabyLakeR.dsl

#ux410 kabylake
if [ ! -d ./$BUILDACPI/ux410-kabylake ]; then mkdir ./$BUILDACPI/ux410-kabylake; fi && rm -Rf $BUILDACPI/ux410-kabylake/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux410-kabylake/SSDT-UX410-KabyLake.aml $SRCHOTPATCH/SSDT-UX410-KabyLake.dsl

#ux430 kabylake
if [ ! -d ./$BUILDACPI/ux430-kabylake ]; then mkdir ./$BUILDACPI/ux430-kabylake; fi && rm -Rf $BUILDACPI/ux430-kabylake/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux430-kabylake/SSDT-UX430-KabyLake.aml $SRCHOTPATCH/SSDT-UX430-KabyLake.dsl

#ux430 kabylake-r
if [ ! -d ./$BUILDACPI/ux430-kabylaker ]; then mkdir ./$BUILDACPI/ux430-kabylaker; fi && rm -Rf $BUILDACPI/ux430-kabylaker/*
cp $BUILDACPI/SSDT-ELAN.aml $BUILDACPI/ux430-kabylaker/SSDT-ELAN.aml
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p $BUILDACPI/ux430-kabylaker/SSDT-UX430-KabyLakeR.aml $SRCHOTPATCH/SSDT-UX430-KabyLakeR.dsl
