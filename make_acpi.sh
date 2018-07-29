#!/bin/bash
sudo rm -rf build
mkdir build
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-UX410-Kabylake.aml hotpatch/SSDT-UX410-Kabylake.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-UX430-Kabylake.aml hotpatch/SSDT-UX430-Kabylake.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-IGPU.aml hotpatch/SSDT-IGPU.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-MOD.aml hotpatch/SSDT-FAN-MOD.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN-READ.aml hotpatch/SSDT-FAN-READ.dsl
