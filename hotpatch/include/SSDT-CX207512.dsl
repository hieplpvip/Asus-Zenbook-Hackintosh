// SSDT to correct some problems headphone/mic on CX20751/2.

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 1, "hack", "cx207512", 0)
{
#endif
    External(_SB.PCI0.HDEF, DeviceObj)
    
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Custom Commands", Package()
            {
                Package(){}, // signifies Array instead of Dictionary
                Package()
                {
                    // 0x16 SET_PIN_WIDGET_CONTROL 0xc0
                    "Command", Buffer() { 0x01, 0x67, 0x07, 0xc0 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x19 SET_PIN_WIDGET_CONTROL 0x24
                    "Command", Buffer() { 0x01, 0x97, 0x07, 0x24 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x1a SET_PIN_WIDGET_CONTROL 0x20
                    "Command", Buffer() { 0x01, 0xa7, 0x07, 0x20 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
            },
            "Perform Reset", ">n",
            "Perform Reset on External Wake", ">n",
        },
    })
#ifndef NO_DEFINITIONBLOCK
}
#endif