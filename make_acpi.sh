#!/bin/bash
IASL=./tools/iasl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-ELAN.aml hotpatch/SSDT-ELAN.dsl
#$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-IGPU.aml hotpatch/SSDT-IGPU.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-MOD.aml hotpatch/SSDT-FAN-MOD.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-READ.aml hotpatch/SSDT-FAN-READ.dsl

#ux410 kabylake
if [ ! -d ./build/ux410-kabylake ]; then mkdir ./build/ux410-kabylake; fi && rm -Rf build/ux410-kabylake/*
#cp build/SSDT-IGPU.aml build/ux410-kabylake/SSDT-IGPU.aml
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux410-kabylake/SSDT-UX410-KabyLake.aml hotpatch/SSDT-UX410-KabyLake.dsl

#ux430 kabylake
if [ ! -d ./build/ux430-kabylake ]; then mkdir ./build/ux430-kabylake; fi && rm -Rf build/ux430-kabylake/*
#cp build/SSDT-IGPU.aml build/ux430-kabylake/SSDT-IGPU.aml
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux430-kabylake/SSDT-UX430-KabyLake.aml hotpatch/SSDT-UX430-KabyLake.dsl

#ux430 kabylake-r
if [ ! -d ./build/ux430-kabylaker ]; then mkdir ./build/ux430-kabylaker; fi && rm -Rf build/ux430-kabylaker/*
#cp build/SSDT-ELAN.aml build/ux430-kabylaker/SSDT-ELAN.aml
#cp build/SSDT-IGPU.aml build/ux430-kabylaker/SSDT-IGPU.aml
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux430-kabylaker/SSDT-UX430-KabyLakeR.aml hotpatch/SSDT-UX430-KabyLakeR.dsl
