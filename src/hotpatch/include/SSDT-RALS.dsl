#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "rals", 0)
{
#endif
    External (ATKP, IntObj)
    External (_SB.ALS, DeviceObj)
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.RALS, MethodObj)
    Scope (_SB.ATKD)
    {
        Method (ALSS, 0, NotSerialized)
        {
            If (CondRefOf(^^PCI0.LPCB.EC0.RALS))
            {
                Return (^^PCI0.LPCB.EC0.RALS ())
            }
            Return (0x0190)
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