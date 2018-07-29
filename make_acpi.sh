#!/bin/bash
sudo rm -rf build
mkdir build

iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-IGPU.aml hotpatch/SSDT-IGPU.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-MOD.aml hotpatch/SSDT-FAN-MOD.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-READ.aml hotpatch/SSDT-FAN-READ.dsl

#ux410 kabylake
mkdir build/ux410
cp build/SSDT-IGPU.aml build/ux410/SSDT-IGPU.aml
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux410/SSDT-UX410-Kabylake.aml hotpatch/SSDT-UX410-Kabylake.dsl

#ux430 kabylake
mkdir build/ux430
cp build/SSDT-IGPU.aml build/ux430/SSDT-IGPU.aml
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/ux430/SSDT-UX430-Kabylake.aml hotpatch/SSDT-UX430-Kabylake.dsl
