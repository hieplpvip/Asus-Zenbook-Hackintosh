// Fake ambient light sensor device
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "als0", 0)
{
#endif
    External (_SB.ATKD, DeviceObj)
    
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
    
    Scope (_SB.ATKD)
    {
        Method (ALSS, 0)
        {
            Return (^^ALS0._ALI)
        }
        
        Method (ALSC, 1)
        {
            // Do nothing
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif