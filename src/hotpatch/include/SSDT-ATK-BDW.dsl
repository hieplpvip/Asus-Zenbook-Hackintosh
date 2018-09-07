#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "atk", 0)
{
#endif
    External (ATKP, IntObj)
    External (_SB.ALS, DeviceObj)
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.ATKD.ALSC, MethodObj)
    External (_SB.KBLV, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
    External (_SB.PCI0.LPCB.EC0.RALS, MethodObj)
    Scope (_SB.ATKD)
    {
        Name (BOFF, 0)
        Method (SKBL, 1, NotSerialized)
        {
            If ((Arg0 == 0xED) || (Arg0 == 0xFD))
            {
                If ((Arg0 == 0xED) && (^BOFF == 0xEA))
                {
                    Local0 = 0
                    ^BOFF = Arg0
                }
                Else
                {
                    If ((Arg0 == 0xFD) && (^BOFF == 0xFA))
                    {
                        Local0 = 0
                        ^BOFF = Arg0
                    }
                    Else
                    {
                        Return (^BOFF)
                    }
                }
            }
            Else
            {
                If ((Arg0 == 0xEA) || (Arg0 == 0xFA))
                {
                    Local0 = ^^KBLV
                    ^BOFF = Arg0
                }
                Else
                {
                    Local0 = Arg0
                    ^^KBLV = Arg0
                }
            }
            Local1 = DerefOf (KBPW [Local0])
            ^^PCI0.LPCB.EC0.WRAM (0x04B1, Local1)
            Return (Local0)
        }
        Name (KBPW, Buffer (0x10)
        {
            0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF
        })
        Method (GKBL, 1, NotSerialized)
        {
            If (Arg0 == 0xFF)
            {
                Return (^BOFF)
            }
            Return (^^KBLV)
        }
        
        Method (ALSS, 0, NotSerialized)
        {
            Return (^^PCI0.LPCB.EC0.RALS ())
        }
        
        Method (EALS, 1, NotSerialized)
        {
            Return (^ALSC (Arg0))
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
        
        Method (_Q0A, 0, NotSerialized) // F1 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x5E)
            }
        }
        
        Method (_Q0B, 0, NotSerialized) // F2 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x7D)
            }
        }
        
        Method (_Q0E, 0, NotSerialized) // F5 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x20)
            }
        }

        Method (_Q0F, 0, NotSerialized) // F6 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x10)
            }
        }
        
        Method (_Q11, 0, NotSerialized) // F8 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x61)
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