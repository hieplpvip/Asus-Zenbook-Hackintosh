#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "atk", 0)
{
#endif
    External (ATKP, IntObj)
    External (_SB.ALS, DeviceObj)
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.KBLV, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ST9E, MethodObj)
    External (_SB.PCI0.LPCB.EC0.RALS, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ALSC, MethodObj)
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
                ElseIf ((Arg0 == 0xFD) && (^BOFF == 0xFA))
                {
                    Local0 = 0
                    ^BOFF = Arg0
                }
                Else
                {
                    Return (^BOFF)
                }
            }
            ElseIf ((Arg0 == 0xEA) || (Arg0 == 0xFA))
            {
                ^BOFF = Arg0
            }
            Else
            {
                ^^KBLV = Arg0 & 0x7F
            }
            
            // **Customizable part from method SLKB
            Local0 = 0x0900
            Local0 += 0xF0
            ^^PCI0.LPCB.EC0.WRAM (Local0, ^^KBLV)
            Local0 = DerefOf (PWKB [^^KBLV])
            ^^PCI0.LPCB.EC0.ST9E (0x1F, 0xFF, Local0)
            // End customizable part**
            Return (Local0)
        }
        
        Name (PWKB, Buffer (0x04)
        {
            0x00, 0x55, 0xAA, 0xFF                         
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
            If (CondRefOf(^^PCI0.LPCB.EC0.RALS))
            {
                Return (^^PCI0.LPCB.EC0.RALS ())
            }
            Return (0x0190)
        }
        
        Method (ALSC, 1, NotSerialized)
        {
            If (CondRefOf(^^PCI0.LPCB.EC0.ALSC))
            {
                Return (^^PCI0.LPCB.EC0.ALSC (Arg0))
            }
            Return (0)
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