#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 1, "hack", "alc295", 0)
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
                    // 0x12 SET_PIN_WIDGET_CONTROL 0x20
                    "Command", Buffer() { 0x01, 0x27, 0x07, 0x20 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x17 SET_PIN_WIDGET_CONTROL 0x40
                    "Command", Buffer() { 0x01, 0x77, 0x07, 0x40 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x19 SET_PIN_WIDGET_CONTROL 0x20
                    "Command", Buffer() { 0x01, 0x97, 0x07, 0x20 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x1d SET_PIN_WIDGET_CONTROL 0x20
                    "Command", Buffer() { 0x01, 0xd7, 0x07, 0x20 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x1e SET_PIN_WIDGET_CONTROL 0x40
                    "Command", Buffer() { 0x01, 0xe7, 0x07, 0x40 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x21 SET_PIN_WIDGET_CONTROL 0xc0
                    "Command", Buffer() { 0x02, 0x17, 0x07, 0xc0 },
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