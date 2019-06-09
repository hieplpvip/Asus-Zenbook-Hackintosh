// Patch by hieplpvip
DefinitionBlock ("SSDT-ELAN", "SSDT", 2, "hack", "elan", 0)
{    
    // replace Method(_STA,0,NS) in Device(GPI0)
    External(_SB.PCI0.GPI0, DeviceObj)
    Method (_SB.PCI0.GPI0._STA, 0)
    {
        Return (0x0F)
    }
    
    // GPIO Pin for ETPD
    External(_SB.PCI0.I2C1.ETPD, DeviceObj)
    Scope (_SB.PCI0.I2C1.ETPD)
    {
        Name (SBFG, ResourceTemplate ()
        {
            GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                )
                {
                    0x55 // Custom pin here
                }
        })
        Method (_CRS, 0, Serialized)
        {
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Return (ConcatenateResTemplate (SBFB, SBFG))
        }
    }
}