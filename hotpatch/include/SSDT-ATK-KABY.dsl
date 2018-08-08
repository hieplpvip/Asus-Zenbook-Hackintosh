#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "atk", 0)
{
#endif
    External (_SB.ALS, DeviceObj)
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (ATKP, IntObj)
    External (_SB.KBLV, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ST9E, MethodObj)
    External (_SB.PCI0.LPCB.EC0.RALS, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ALSC, MethodObj)
    Scope (_SB.ATKD)
    {
        Name (BOFF, Zero)
        Method (SKBL, 1, NotSerialized)
        {
            If (Or (LEqual (Arg0, 0xED), LEqual (Arg0, 0xFD)))
            {
                If (And (LEqual (Arg0, 0xED), LEqual (^BOFF, 0xEA)))
                {
                    Store (Zero, Local0)
                    Store (Arg0, ^BOFF)
                }
                ElseIf (And (LEqual (Arg0, 0xFD), LEqual (^BOFF, 0xFA)))
                {
                    Store (Zero, Local0)
                    Store (Arg0, ^BOFF)
                }
                Else
                {
                    Return (^BOFF)
                }
            }
            ElseIf (Or (LEqual (Arg0, 0xEA), LEqual (Arg0, 0xFA)))
            {
                Store (Arg0, ^BOFF)
            }
            Else
            {
                Store (And (Arg0, 0x7F), ^^KBLV)
            }
            
            // **Customizable part from method SLKB
            Store (0x0900, Local0)
            Add (Local0, 0xF0, Local0)
            ^^PCI0.LPCB.EC0.WRAM (Local0, ^^KBLV)
            Store (DerefOf (Index (PWKB, ^^KBLV)), Local0)
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
            If (LEqual (Arg0, 0xFF))
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
            Return (^^PCI0.LPCB.EC0.ALSC (Arg0))
        }
    }
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        // Ambient light sensor notification, from EMlyDinEsH
        Method (_QCD, 0, NotSerialized)
        {
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
            // Empty method
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
    }
    
    Scope (_SB.ALS)
    {
        Name(_CID, "smc-als")
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif