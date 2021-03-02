## General guides

- RehabMan
  - [[FAQ] READ FIRST! Laptop Frequent Questions](https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/)
  - [[README] Common Problems in 10.13 High Sierra](https://www.tonymacx86.com/threads/readme-common-problems-in-10-13-high-sierra.233582/)
  - [[Guide] Alternative to the minStolenSize patch with 32mb DVMT-prealloc](https://www.tonymacx86.com/threads/guide-alternative-to-the-minstolensize-patch-with-32mb-dvmt-prealloc.221506/)
  - [[Guide] Avoid APFS conversion on High Sierra update or fresh install](https://www.tonymacx86.com/threads/guide-avoid-apfs-conversion-on-high-sierra-update-or-fresh-install.232855/)
  - [[Guide] Booting the OS X installer on LAPTOPS with Clover](https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/)
  - [[Guide] Patching LAPTOP DSDT/SSDTs](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/)
  - [[Guide] How to patch DSDT for working battery status](https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/)
  - [[Guide] Native Power Management for Laptops](https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/)
  - [[Guide] Laptop backlight control using AppleBacklightFixup.kext](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightfixup-kext.218222/)
  - [[Guide] Disabling discrete graphics in dual-GPU laptops](https://www.tonymacx86.com/threads/guide-disabling-discrete-graphics-in-dual-gpu-laptops.163772/)
  - [[Guide] Creating a Custom SSDT for USBInjectAll.kext](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)
  - [[Guide] USB power property injection for Sierra (and later)](https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/)
  - [[Guide] Using Clover to "hotpatch" ACPI](https://www.tonymacx86.com/threads/guide-using-clover-to-hotpatch-acpi.200137/)
  - [[FIX] "Window Server Service only ran for 0 seconds" with dual-GPU](https://www.tonymacx86.com/threads/fix-window-server-service-only-ran-for-0-seconds-with-dual-gpu.233092/)
  - [[Fix] HD4200/HD4400/HD4600/HD5600 on 10.11+](https://www.tonymacx86.com/threads/fix-hd4200-hd4400-hd4600-hd5600-on-10-11.175797/)
- Sniki
  - [[README] Common Problems/Changes/Fixes on Mojave](https://www.tonymacx86.com/threads/readme-common-problems-changes-fixes-on-mojave.255823/)
- toleda
  - [Broadcom WiFi/Bluetooth [Guide]](https://www.tonymacx86.com/threads/broadcom-wifi-bluetooth-guide.242423/)
- EMlyDinEsH
  - [Complete AppleHDA Patching Guide](http://forum.osxlatitude.com/index.php?/topic/1946-complete-applehda-patching-guide/)
  - [Fn HotKey and ALS sensor driver for Asus Notebooks](https://osxlatitude.com/forums/topic/1968-fn-hotkey-and-als-sensor-driver-for-asus-notebooks/)
  - [AsusNBFnKeys source code](https://github.com/EMlyDinEsHMG/AsusNBFnKeys)
- Mirone
  - [Guide to patch AppleHDA for your codec](http://www.insanelymac.com/forum/topic/295001-guide-to-patch-applehda-for-your-codec/)
- insanelydeepak
  - [AIO Complete Guide to Patch AppleHDA for Your Codec](http://osxarena.com/2015/03/best-all-in-one-patch-applehda-guide/)
- holyfield, Pike R. Alpha and many others:
  - [Pattern of MLB (Main Logic Board)](http://www.insanelymac.com/forum/topic/303073-pattern-of-mlb-main-logic-board/)
- Hervé
  - [Performance tuning with FakeSMC & SMBIOS plist](http://www.osxlatitude.com/tuning-performance-with-fakesmc-smbios-plist/)
- black.dragon74
  - [How to implement custom fan control on ASUS laptops](https://osxlatitude.com/forums/topic/10244-how-to-implement-custom-fan-control-on-asus-laptops/)
- jaymonkey
  - [How to Fix iMessage](http://www.tonymacx86.com/threads/how-to-fix-imessage.110471/)
- P1LGRIM
  - [An iDiot's Guide To iMessage](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/)

## Kexts used in this build

- Acidanthera (vit9696, lvs1974, etc.)
  - [Lilu](https://github.com/acidanthera/Lilu)
  - [AppleALC](https://github.com/acidanthera/AppleALC)
  - [AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup)
  - [BT4LEContinuityFixup](https://github.com/acidanthera/BT4LEContinuityFixup)
  - [VirtualSMC](https://github.com/acidanthera/VirtualSMC) and its plugins
  - [WhateverGreen](https://github.com/acidanthera/WhateverGreen)
- PMheart
  - [LiluFriend](https://github.com/PMheart/LiluFriend)
- alexandred, coolstar, kprinssu, blankmac
  - [VoodooI2C](https://github.com/alexandred/VoodooI2C)
- hieplpvip (me)
  - [AsusSMC](https://github.com/hieplpvip/AsusSMC)
- RehabMan
  - [ACPIPoller](https://bitbucket.org/RehabMan/os-x-acpi-poller)
  - [BrcmPatchRAM](https://bitbucket.org/RehabMan/os-x-brcmpatchram)
  - [CodecCommander](https://bitbucket.org/RehabMan/os-x-eapd-codec-commander)
  - [NullEthernet](https://bitbucket.org/RehabMan/os-x-null-ethernet)
  - [USBInjectAll](https://bitbucket.org/RehabMan/os-x-usb-inject-all)
  - [VoodooPS2Controller](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/src/master/)
- Unknown
  - x86PlatformPluginInjector

## UEFI drivers used in this build

- Acidanthera (vit9696, lvs1974, etc.)
  - [AptioFixPkg](https://github.com/acidanthera/AptioFixPkg)
  - [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg)

## Guides I used to get started

- gulios
  - [Asus - UX430UA - Kaby Lake i7-7500U Intel HD Graphics 620](https://www.tonymacx86.com/threads/asus-ux430ua-kaby-lake-intel-hd-graphics-620.225847)
- Shinji3rd
  - [[Guide] ASUS Zenbook UX310UA MacOS Sierra / High Sierra Installation Guide](https://www.tonymacx86.com/threads/guide-asus-zenbook-ux310uak-macos-sierra-installation-guide.224591)

## Others

- syscl
  - [XPS9350-macOS](https://github.com/syscl/XPS9350-macOS)
- blazinsmokey
  - [[Guide] Dell XPS 9560 Mojave VirtualSMC, I2C Trackpad, Clover UEFI Hotpatch](https://www.tonymacx86.com/threads/guide-dell-xps-9560-mojave-virtualsmc-i2c-trackpad-clover-uefi-hotpatch.263567/)
