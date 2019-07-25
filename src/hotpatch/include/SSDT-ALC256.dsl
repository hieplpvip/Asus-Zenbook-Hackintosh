#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 1, "hack", "alc256", 0)
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
                    // 0x19 SET_PIN_WIDGET_CONTROL 0x24
                    "Command", Buffer() { 0x01, 0x97, 0x07, 0x24 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x1A SET_PIN_WIDGET_CONTROL 0x20
                    "Command", Buffer() { 0x01, 0xA7, 0x07, 0x20 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x21 SET_UNSOLICITED_ENABLE 0x83
                    "Command", Buffer() { 0x02, 0x17, 0x08, 0x83 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                }
            },
            "Perform Reset", ">n",
            "Perform Reset on External Wake", ">n",
            "Send Delay", 10,
            "Sleep Nodes", ">n",
        },
    })
#ifndef NO_DEFINITIONBLOCK
}
#endif