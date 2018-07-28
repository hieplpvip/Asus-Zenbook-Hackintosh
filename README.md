# ASUS ZENBOOK
Clover hotpatches and tools for the Asus Zenbook laptop on macOS 10.13.6. 

#### Supported models:

* UX410
* UX430

#### What you should expect works

* Audio
* Keyboard
* Trackpad
* Battery
* Fn-keys
* Brightness
* Sleep
* HDMI

#### Will never work

* Factory Intel WiFi card (need to replace with DW1560)

## Basic Instruction

Please read all before starting

### 1. BIOS Settings

* Update to latest BIOS version
* Activate Advanced Mode
* Set DVMT to 64M
* Disable Secure Boot

### 2. Preparing USB

* Follow this [guide](https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/)
* Use config.plist from this repo
* For the drivers, use AptioMemoryFix.efi, ApfsDriverLoader.efi, HFSPlus.efi
* For the kexts, run this in Terminal:
```
cd ~
git clone https://github.com/hieplpvip/ASUS-ZENBOOK-HACKINTOSH.git zenbook
cd zenbook && sudo ./download.sh
```
Copy the kexts in downloads/clover_kexts to Clover.

### 3. Post Installation

* Install Clover UEFI as described in the guide linked by the previous section.
* In Terminal:
```
cd ~
git clone https://github.com/hieplpvip/ASUS-ZENBOOK-HACKINTOSH.git zenbook
cd zenbook
sudo ./download.sh && sudo ./install_downloads.sh
sudo ./make_acpi.sh && sudo ./install_acpi.sh
```
* Copy config.plist to Clover

### 4. Completing Hackintosh

* To fix iMessage, follow this [guide](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/). I recommend using config.plist created from that guide to do a fresh install.

## Issues
* If you have any problems, open a new issues, attach output from this [tool](https://www.tonymacx86.com/threads/tool-generate-proper-problem-reporting-files.235953/).

## Notes
- Trackpad: VoodooI2C has two modes: GPIO pinning and polling. For better performance, GPIO pinning mode should be used. However, ASUS laptops (UX410, UX430, etc) have problems with GPIO pinning. Therefore, polling mode is used. New ASUS laptops seem to fix this. If you want to test, compile SSDT-ELAN with your custom pin (follow [this guide](https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning) to know) and enable these 2 patch in config.plist: "change Method(_STA,0,NS) in GPI0 to XSTA" and "change Method(_CRS,0,S) in ETPD to XCRS".

## WIP

* [VoodooI2C](https://github.com/hieplpvip/VoodooI2C/tree/native)
* [AsusFnKeys](https://github.com/hieplpvip/AsusFnKeys)

## To-Do

* Bluetooth & WiFi (just need to replace Intel card with DW1560)
* Post a full guide on Tonymacx86

## Credits

@gulios (see https://www.tonymacx86.com/threads/asus-ux430ua-kaby-lake-intel-hd-graphics-620.225847) 

@Shinji3rd (see https://www.tonymacx86.com/threads/guide-asus-zenbook-ux310uak-macos-sierra-installation-guide.224591)

@alexandred for the the touchpad driver.

@RehabMan for everything else

## [Donate me](https://paypal.me/hieplpvip)
Any donation is highly appreciated
