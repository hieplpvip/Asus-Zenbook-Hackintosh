## [Donate me](https://paypal.me/lebhiep)
As a student, I need to pay a lot of fees: tuition fees, exam fees, house rent, food, etc.
Any donation would help me a lot!

This repository is provided for free in the hope of helping people who can't afford Macbook install macOS on their Zenbooks, and it will always be free.

# ASUS ZENBOOK HACKINTOSH

[![Gitter chat](https://img.shields.io/gitter/room/nwjs/nw.js.svg?colorB=ed1965)](https://gitter.im/ASUS-ZENBOOK-HACKINTOSH/Lobby)

Clover hotpatches and tools for the Asus Zenbook laptop on macOS 10.13.6+

## Supported models

- UX310 (KabyLake)
- UX330 (KabyLake) (not tested)
- UX330 (KabyLake-R)
- UX410 (KabyLake)
- UX430 (KabyLake)
- UX430 (KabyLake-R)

To add support for your laptop, please provide full specs and original ACPI files from Clover. Recent models (KabyLake, KabyLake-R) are preferred.

## Current Status

- Trackpad sometimes stops working for a few minutes (A sleep would fix it). Otherwise it works beautifully.
- Wifi/Bluetooth: need to replace with DW1560. Stock Intel card will never work. Bluetooth sometimes stops working after sleep.
- Audio doesn't work perfectly on some models.
- Everything else works well.

## Instruction

- Basic instruction is available in [wiki](../../wiki/).

## Topic on tonymacx86

[[Guide] Asus Zenbook using Clover UEFI hotpatch](https://www.tonymacx86.com/threads/guide-asus-zenbook-using-clover-uefi-hotpatch.257448/)

## Credits

@alexandred and his team for VoodooI2C

@acidanthera (@vit9696, @lvs1974, @vandroiy2013, etc.) for Lilu, AppleALC, VirtualSMC, WhateverGreen, AirportBrcmFixup, BT4LEContinuityFixup and their EFI drivers.

@gulios (see https://www.tonymacx86.com/threads/asus-ux430ua-kaby-lake-intel-hd-graphics-620.225847) 

@Shinji3rd (see https://www.tonymacx86.com/threads/guide-asus-zenbook-ux310uak-macos-sierra-installation-guide.224591)

@black.dragon74 for custom FAN control (see https://osxlatitude.com/forums/topic/10244-how-to-implement-custom-fan-control-on-asus-laptops/)

and many more that I can't list here. See [References](../../wiki/References) for full list.

Special thanks: @RehabMan
