#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "alsc", 0)
{
#endif
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.WMNB.ALSC, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ALSC, MethodObj)
    Scope (_SB.ATKD)
    {
        Method (ALSC, 1)
        {
            If (CondRefOf(^^PCI0.LPCB.EC0.ALSC))
            {
                Return (^^PCI0.LPCB.EC0.ALSC (Arg0))
            }
            If (CondRefOf(^WMNB.ALSC))
            {
                Return (^WMNB.ALSC (Arg0))
            }
            Return (0)
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif