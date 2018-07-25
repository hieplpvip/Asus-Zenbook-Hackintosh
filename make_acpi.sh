#!/bin/bash
rm -rf build
mkdir build
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-ATK.aml hotpatch/SSDT-ATK.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-BATT.aml hotpatch/SSDT-BATT.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-FAN.aml hotpatch/SSDT-FAN.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-HACK.aml hotpatch/SSDT-HACK.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-PNLF.aml hotpatch/SSDT-PNLF.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-PTSWAK.aml hotpatch/SSDT-PTSWAK.dsl
iasl -vw 2095 -vw 2146 -vw 2089 -vw 4089 -vi -vr -p build/SSDT-UIAC.aml hotpatch/SSDT-UIAC.dsl
