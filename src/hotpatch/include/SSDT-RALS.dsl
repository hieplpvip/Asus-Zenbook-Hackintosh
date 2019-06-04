#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "rals", 0)
{
#endif
    External (_SB.ATKP, IntObj)
    External (_SB.ALS, DeviceObj)
    External (_SB.ATKD, DeviceObj)
    External (_SB.ALAE, FieldUnitObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.XALS, MethodObj)
    
    // In DSDT, native RALS is renamed to XALS with Clover binpatch.
    // As a result, calls to RALS land here.
    // This is a hack to allow setting keyboard backlight when ALS is disabled
    Method (_SB.PCI0.LPCB.EC0.RALS, 0)
    {
        If (ALAE)
        {
            Return (^XALS ())
        }
        Else
        {
            Return (150)
        }
    }
        
    Scope (_SB.ATKD)
    {
        Method (ALSS, 0)
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
        Method (_QCD, 0)
        {
            Notify (ALS, 0x80)
            If (^^^^ATKP)
            {
                ^^^^ATKD.IANE (0xC6)
            }
        }

        Method (_Q76, 0) // Fn+A
        {
            If (^^^^ATKP)
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