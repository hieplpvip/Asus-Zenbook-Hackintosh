# ASUS ZENBOOK UX410
Clover hotpatches and tools for the ASUS UX410 laptop on macOS 10.13.5

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

* Factory Intel WiFi card.

## Notes:
- Trackpad: VoodooI2C has two modes: GPIO pinning and polling. For better performance, GPIO pinning mode should be used. However, ASUS laptops (UX410, UX430, etc) have problems with GPIO pinning. Therefore, polling mode is used. New ASUS laptops seem to fix this. If you want to test, compile SSDT-ELAN with your custom pin and enable these 2 patch in config.plist: "change Method(_STA,0,NS) in GPI0 to XSTA" and "change Method(_CRS,0,S) in ETPD to XCRS".
- SSDT-UIAC is made specially for my laptop. On yours USB ports may be different. See [this guide](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/) for how to create one for yours.

## To-Do

* Create my own version of VoodooI2C: https://github.com/hieplpvip/VoodooI2C (WIP)
* Bluetooth & WiFi (just need to replace Intel card with DW1560, but I don't have money now :(( )
* Create automatic scripts
* Post a full guide on Tonymacx86

## Credits

@gulios (see https://www.tonymacx86.com/threads/asus-ux430ua-kaby-lake-intel-hd-graphics-620.225847) 

@Shinji3rd (see https://www.tonymacx86.com/threads/guide-asus-zenbook-ux310uak-macos-sierra-installation-guide.224591)

@alexandred for the the touchpad driver.

@RehabMan for everything else

## [Donate me](paypal.me/hieplpvip)
Any donation is highly appreciated

