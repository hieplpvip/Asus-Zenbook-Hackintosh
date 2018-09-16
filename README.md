# ASUS ZENBOOK HACKINTOSH

[![Join the chat at https://gitter.im/ASUS-ZENBOOK-HACKINTOSH/Lobby](https://badges.gitter.im/ASUS-ZENBOOK-HACKINTOSH/Lobby.svg)](https://gitter.im/ASUS-ZENBOOK-HACKINTOSH/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Clover hotpatches and tools for the Asus Zenbook laptop on macOS 10.13.6

## Supported models

- UX310 (KabyLake)
- UX330 (KabyLake) (not tested)
- UX330 (KabyLake-R)
- UX410 (KabyLake)
- UX430 (KabyLake)
- UX430 (KabyLake-R)

To add support for your laptop, please provide full specs and original ACPI files from Clover. Recent models (KabyLake, KabyLake-R) are preferred.

## What's working now

- Trackpad has some minor bugs (random cursor jumping, etc.), but gestures are great
- Wifi/Bluetooth: replace with DW1560. Stock Intel card will never work
- Audio not working 100% on UX430
- ALS not working (will add support for it when [VirtualSMC](https://github.com/acidanthera/VirtualSMC) is released)
- Keyboard backlight with 16 levels even on new laptops (Windows only supports 3). Sounds crazy, right? 
- Everything else works well

## Instruction

- Basic instruction is available on the [wiki](https://github.com/hieplpvip/ASUS-ZENBOOK-HACKINTOSH/wiki).

## Guide on tonymacx86

[[Guide] Asus Zenbook using Clover UEFI hotpatch](https://www.tonymacx86.com/threads/guide-asus-zenbook-using-clover-uefi-hotpatch.257448/)

## WIP Kexts

* [VoodooI2C](https://github.com/hieplpvip/VoodooI2C/tree/native)
* [AsusFnKeys](https://github.com/hieplpvip/AsusFnKeys)

## Credits

@alexandred for VoodooI2C

@vit9696 for Lilu, AppleALC, WhateverGreen, AptioMemoryFix and ApfsDriverLoader

@gulios (see https://www.tonymacx86.com/threads/asus-ux430ua-kaby-lake-intel-hd-graphics-620.225847) 

@Shinji3rd (see https://www.tonymacx86.com/threads/guide-asus-zenbook-ux310uak-macos-sierra-installation-guide.224591)

@black.dragon74 for custom FAN control (see https://osxlatitude.com/forums/topic/10244-how-to-implement-custom-fan-control-on-asus-laptops/)

Special thanks: @RehabMan

See [References](../../wiki/References) for full list.

## [Donate me](https://paypal.me/hieplpvip)
Any donation is highly appreciated
