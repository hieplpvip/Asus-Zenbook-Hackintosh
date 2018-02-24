DefinitionBlock ("", "SSDT", 2, "hack", "fn", 0x00000000)
{
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (ATKP, IntObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
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

        Method (_Q0C, 0, NotSerialized) // F3 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x50)
            }
        }

        Method (_Q0D, 0, NotSerialized) // F4 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x51)
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

        Method (_Q10, 0, NotSerialized) // F7 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x35)
            }
        }

        Method (_Q11, 0, NotSerialized) // F8 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x61)
            }
        }

        Method (_Q12, 0, NotSerialized) // F9 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x6B)
            }
        }

        Method (_Q13, 0, NotSerialized) // F10 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x32)
            }
        }

        Method (_Q14, 0, NotSerialized) // F11 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x31)
            }
        }

        Method (_Q15, 0, NotSerialized) // F12 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x30)
            }
        }
    }
}

