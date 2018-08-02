# ASUS ZENBOOK
Clover hotpatches and tools for the Asus Zenbook laptop on macOS 10.13.6.

## Guide on tonymacx86:

[[Guide] Asus Zenbook using Clover UEFI hotpatch](https://www.tonymacx86.com/threads/guide-asus-zenbook-using-clover-uefi-hotpatch.257448/)

## Notes
- Trackpad: VoodooI2C has two modes: GPIO pinning and polling. For better performance, GPIO pinning mode should be used. However, ASUS laptops (UX410, UX430, etc) have problems with GPIO pinning. Therefore, polling mode is used. New ASUS laptops seem to fix this. If you want to test, compile SSDT-ELAN with your custom pin (follow [this guide](https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning) to know) and enable these 2 patch in config.plist: "change Method(_STA,0,NS) in GPI0 to XSTA" and "change Method(_CRS,0,S) in ETPD to XCRS".

## WIP

* [VoodooI2C](https://github.com/hieplpvip/VoodooI2C/tree/native)
* [AsusFnKeys](https://github.com/hieplpvip/AsusFnKeys)

## Credits

@gulios (see https://www.tonymacx86.com/threads/asus-ux430ua-kaby-lake-intel-hd-graphics-620.225847) 

@Shinji3rd (see https://www.tonymacx86.com/threads/guide-asus-zenbook-ux310uak-macos-sierra-installation-guide.224591)

@alexandred for the the touchpad driver.

@black.dragon74 for custom FAN control (see https://osxlatitude.com/forums/topic/10244-how-to-implement-custom-fan-control-on-asus-laptops/)

@RehabMan for everything else

## [Donate me](https://paypal.me/hieplpvip)
Any donation is highly appreciated
