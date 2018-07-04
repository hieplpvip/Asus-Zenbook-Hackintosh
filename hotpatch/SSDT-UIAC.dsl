// SSDT-UIAC-ALL.dsl
//
// This SSDT can be used as a template to build your own
// customization for USBInjectAll.kext.
//
// This SSDT contains all ports, so using it is the same as without
// a custom SSDT.  Delete ports that are not connected or ports you
// do not need.
//
// Change the UsbConnector or portType as needed to match your
// actual USB configuration.
//
// Note:
// portType=0 seems to indicate normal external USB2 port (as seen in MacBookPro8,1)
// portType=2 seems to indicate "internal device" (as seen in MacBookPro8,1)
// portType=4 is used by MacBookPro8,3 (reason/purpose unknown)
//

DefinitionBlock ("", "SSDT", 2, "hack", "UIAC-ALL", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "8086_9d2f", Package()
            {
                "port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package() // HS of Left 3.0
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // Right 2.0
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // Right 2.0
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS06", Package() // Webcam
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS08", Package() // Bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    "HS10", Package() // Left 2.0 Type-C
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 10, 0, 0, 0 },
                    },
                    "SS01", Package() // Left 3.0
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                },
            },
        })
    }
}