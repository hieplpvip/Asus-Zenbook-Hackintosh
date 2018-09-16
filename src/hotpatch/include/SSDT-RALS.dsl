#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "rals", 0)
{
#endif
    External (ATKP, IntObj)
    External (_SB.ALS, DeviceObj)
    External (_SB.ATKD, DeviceObj)
    External (_SB.ALAE, FieldUnitObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.XALS, MethodObj)
    
    // In DSDT, native RALS is renamed to XALS with Clover binpatch.
    // As a result, calls to RALS land here.
    // The purpose of this implementation is to report proper ALS value
    // when the sensor is disabled.
    // Original RALS returns 0x190 (corresponding to 125%, or increase
    // brightness by 25% based on value set by user)
    // Modified RALS returns 0x12C (corresponding to 100%)
    // For more information find OALR in DSDT and read about _ALR in
    // http://www.acpi.info/DOWNLOADS/ACPIspec30b.pdf
    Method (_SB.PCI0.LPCB.EC0.RALS, 0, NotSerialized)
    {
        If (ALAE)
        {
            Return (^XALS ())
        }
        Else
        {
            Return (0x12C)
        }
    }
        
    Scope (_SB.ATKD)
    {
        Method (ALSS, 0, NotSerialized)
        {
            If (CondRefOf(^^PCI0.LPCB.EC0.RALS))
            {
                Return (^^PCI0.LPCB.EC0.RALS ())
            }
            Return (0x012C)
        }
    }
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        // Ambient light sensor notification, from EMlyDinEsH
        Method (_QCD, 0, NotSerialized)
        {
            Notify (ALS, 0x80)
            If (ATKP)
            {
                ^^^^ATKD.IANE (0xC6)
            }
        }

        Method (_Q76, 0, NotSerialized)  // Fn+A
        {
            If (ATKP)
            {
                ^^^^ATKD.IANE (0x7A)
            }
        }
    }
    
    Scope (_SB.ALS)
    {
        Name(_CID, "smc-als")
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif