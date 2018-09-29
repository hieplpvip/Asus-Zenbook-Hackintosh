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
        Name(_ALI, 300)
        Name(_ALR, Package()
        {
            //Package() { 70, 0 },
            //Package() { 73, 10 },
            //Package() { 85, 80 },
            Package() { 100, 300 },
            //Package() { 150, 1000 },
        })
    }
    
    Scope (_SB.ATKD)
    {
        Method (ALSS, 0, NotSerialized)
        {
            Return (^^ALS0._ALR)
        }
        
        Method (ALSC, 1, NotSerialized)
        {
            // Do nothing
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif