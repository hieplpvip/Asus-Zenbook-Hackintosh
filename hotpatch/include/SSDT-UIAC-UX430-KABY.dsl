// Asus UX430UA. Credit: @gulios

// USB ports:

// USB-C(left side):
//	HS04 -> pendrive USB2
//	SS04 -> pendrive USB3
//	HS04 -> logitech 2.4G reciver
//	HS04 -> monitor hdmi->usb-c
//	
// USB3(left side):
//	HS01 -> pendrive USB2
//	SS01 -> pendrive USB3
//	HS01 -> logitech 2.4G reciver
//	
// USB2(right side):
//	HS02 -> pendrive USB2
//	HS02 -> pendrive USB3
//	HS02 -> logitech 2.4G reciver
// 
// CARD READER 
//	HS05 -> cards
//	
// Internal devices:	
// HS08: 
//	Broadcom wifi+bt
// HS06: 
//	USB2.0 HD UVC WebCam
// HS09:
//	ELAN:Fingerprint
// 
// so it uses: 
//    HS01, HS02, HS04, HS05, HS06, HS08, HS09
//    SS01, SS04
//
// !!! HS09 is for ELAN:fingerprint It doesn;t work so we want to disable it


#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "uiac", 0)
{
#endif
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            "8086_9d2f", Package()
            {
                "port-count", Buffer() { 15, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS04", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS05", Package()
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS06", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS08", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "SS01", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "SS04", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                },
            },
        })
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif