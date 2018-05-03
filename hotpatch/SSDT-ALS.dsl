DefinitionBlock ("SSDT-ALS", "SSDT", 2, "hack", "als", 0)
{
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.RALS, MethodObj)
    External(_SB.PCI0.LPCB.EC0.ALSC, MethodObj)
    External(ATKP, IntObj)
    External(_SB.ALS, DeviceObj)
    External(_SB.ALAE, FieldUnitObj)
    External(_SB.ATKD, DeviceObj)    
    External(_SB.ATKD.IANE, MethodObj)
    External(_SB.ATKD.SKBL, MethodObj)

    External (RMDT, DeviceObj)
    External (RMDT.PUSH, MethodObj)
    External (RMDT.P1, MethodObj)
    External (RMDT.P2, MethodObj)
    External (RMDT.P3, MethodObj)
    External (RMDT.P4, MethodObj)
    External (RMDT.P5, MethodObj)
    External (RMDT.P6, MethodObj)
    External (RMDT.P7, MethodObj)
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        // Ambient light sensor notification, from EMlyDinEsH
        Method (_QCD, 0, NotSerialized)
        {
            Notify (^^^^ALS, 0x80)
            If (ATKP)
            {
                ^^^^ATKD.IANE (0xC6)
                ^^^^ATKD.CKBL ()
            }
        }

        Method (_Q76, 0, NotSerialized)  // Fn+A
        {
            If (ATKP)
            {
                ^^^^ATKD.IANE (0x7A)
                If (^^^^ALAE)
                {
                    // disable ALS sensor
                    ^^^^PCI0.LPCB.EC0.ALSC (Zero)
                    \RMDT.P1("Disabled ALS sensor")
                }
                Else
                {
                    // enable ALS sensor
                    ^^^^PCI0.LPCB.EC0.ALSC (One)
                    \RMDT.P1("Enabled ALS sensor")
                    ^^^^ATKD.CKBL ()
                }
            }
        }
    }

    
    Scope (_SB.ATKD)
    {
        Method (ALSS, 0, NotSerialized)
        {
            Return (^^PCI0.LPCB.EC0.RALS ())
        }
        
        Method (CKBL, 0, NotSerialized)
        {
            If (^^ALAE)
            {
                Store (^^ATKD.ALSS(), Local0)
                \RMDT.P2("ALS sensor:", Local0)
                If (LLessEqual (Local0, 0x3C))
                {
                    SKBL (3)
                }
                ElseIf (LAnd (LLessEqual (Local0, 0x82), LGreater (Local0, 0x3C)))
                {
                    SKBL (2)
                }
                ElseIf (LAnd (LLessEqual (Local0, 0xFF), LGreater (Local0, 0x82)))
                {
                    SKBL (1)
                }
                Else
                {
                    SKBL (0)
                }
            }
        }
    }

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
}
    
