#!/bin/bash
IASL=./tools/iasl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-ELAN.aml hotpatch/SSDT-ELAN.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-MOD.aml hotpatch/SSDT-FAN-MOD.dsl
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-READ.aml hotpatch/SSDT-FAN-READ.dsl

#ux303 broadwell
if [ ! -d ./build/ux303-broadwell ]; then mkdir ./build/ux303-broadwell; fi && rm -Rf build/ux303-broadwell/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux303-broadwell/SSDT-UX303-Broadwell.aml hotpatch/SSDT-UX303-Broadwell.dsl

#ux310 kabylake
if [ ! -d ./build/ux310-kabylake ]; then mkdir ./build/ux310-kabylake; fi && rm -Rf build/ux310-kabylake/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux310-kabylake/SSDT-UX310-KabyLake.aml hotpatch/SSDT-UX310-KabyLake.dsl

#ux410 kabylake
if [ ! -d ./build/ux410-kabylake ]; then mkdir ./build/ux410-kabylake; fi && rm -Rf build/ux410-kabylake/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux410-kabylake/SSDT-UX410-KabyLake.aml hotpatch/SSDT-UX410-KabyLake.dsl

#ux430 kabylake
if [ ! -d ./build/ux430-kabylake ]; then mkdir ./build/ux430-kabylake; fi && rm -Rf build/ux430-kabylake/*
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux430-kabylake/SSDT-UX430-KabyLake.aml hotpatch/SSDT-UX430-KabyLake.dsl

#ux430 kabylake-r
if [ ! -d ./build/ux430-kabylaker ]; then mkdir ./build/ux430-kabylaker; fi && rm -Rf build/ux430-kabylaker/*
cp build/SSDT-ELAN.aml build/ux430-kabylaker/SSDT-ELAN.aml
$IASL -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux430-kabylaker/SSDT-UX430-KabyLakeR.aml hotpatch/SSDT-UX430-KabyLakeR.dsl
