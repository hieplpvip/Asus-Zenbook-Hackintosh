#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "HIEP", "DDGPU", 0)
{
#endif
    External(_SB.PCI0.RP01.PEGP._OFF, MethodObj) // Found in SSDT-10
    External(_SB.PCI0.HGOF, MethodObj)           // Found in SSDT-9

    Device(RMD1) {
        Name(_HID, "RMD10000")

        Method(_INI)
        {
            If (CondRefOf(\_SB.PCI0.RP01.PEGP._OFF)) {
                \_SB.PCI0.RP01.PEGP._OFF()
            }
        }

        // HGOF is present in _OFF, seems to disable fan
        // However, it involves EC access
        // Therefore, it needs to be called after EC is fully initialized
        // See method _REG under _SB.PCI0.LPCB.EC0 in SSDT_HACK
        Method(HGOF, 1) {
            If (CondRefOf(\_SB.PC0.HGOF)) {
                \_SB.PCI0.HGOF(Arg0)
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
