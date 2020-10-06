// Fake ambient light sensor device
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "HIEP", "ALS0", 0)
{
#endif
    Device(_SB.ALS0)
    {
        Name(_HID, "ACPI0008")
        Name(_CID, "smc-als")
        Name(_ALI, 150)
        Name(_ALR, Package()
        {
            Package() { 100, 150 },
        })
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
