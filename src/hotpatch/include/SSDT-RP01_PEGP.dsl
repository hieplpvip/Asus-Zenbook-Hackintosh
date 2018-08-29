#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "rp01pegp", 0)
{
#endif
    External(_SB.PCI0.RP01.PEGP, DeviceObj)
    External(_SB.PCI0.RP01.PEGP._OFF, MethodObj)
    External(_SB.PCI0.RP01.PEGP._ON, MethodObj)
    External(_SB.PCI0.HGOF, MethodObj)
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove
        Method(RMOF) { If (CondRefOf(\_SB.PCI0.RP01.PEGP._OFF)) { \_SB.PCI0.RP01.PEGP._OFF() } }
        Method(RMON) { If (CondRefOf(\_SB.PCI0.RP01.PEGP._ON)) { \_SB.PCI0.RP01.PEGP._ON() } }
        Method(HGOF, 1) { If (CondRefOf(\_SB.PCI0.HGOF)) { \_SB.PCI0.HGOF(Arg0) } }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif