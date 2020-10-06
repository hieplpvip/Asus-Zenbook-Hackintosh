#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "HIEP", "RALS", 0)
{
#endif
    External (_SB.ATKP, IntObj)
    External (_SB.ATKD.IANE, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (_Q76, 0) // Fn+A
        {
            If (^^^^ATKP)
            {
                ^^^^ATKD.IANE (0x7A)
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
