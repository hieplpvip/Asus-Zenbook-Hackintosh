DefinitionBlock ("SSDT-FN", "SSDT", 2, "hack", "fn", 0)
{
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (ATKP, IntObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {

        Method (_Q0B, 0, NotSerialized) // F2 key
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x5F)
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
    }
}

