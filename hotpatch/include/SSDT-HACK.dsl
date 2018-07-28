#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
{
#endif
    // All _OSI calls in DSDT are routed to XOSI...
    // As written, this XOSI simulates "Windows 2015" (which is Windows 10)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    //  Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        // simulation targets
        // source: (google 'Microsoft Windows _OSI')
        //  https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi
        Local0 = Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            //"Windows 2001.1",     // Windows Server 2003
            //"Windows 2001.1 SP1", // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            "Windows 2006.1",       // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            "Windows 2013",         // Windows 8.1/Windows Server 2012 R2
            "Windows 2015",         // Windows 10/Windows Server TP
            //"Windows 2016",       // Windows 10, version 1607
            //"Windows 2017",       // Windows 10, version 1703
            //"Windows 2017.2",     // Windows 10, version 1709
            //"Windows 2018",       // Windows 10, version 1803
        }
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }
    
	// In DSDT, native GPRW is renamed to XPRW with Clover binpatch.
    // As a result, calls to GPRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
	Method(GPRW, 2, NotSerialized)
	{
		If (0x6d == Arg0) { Return(Package() { 0x6d, 0, }) }
		If (0x0d == Arg0) { Return(Package() { 0x0d, 0, }) }
		External(\XPRW, MethodObj)
		Return(XPRW(Arg0, Arg1))
	}
    
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XREG, MethodObj)
    External(RMCF.HGOF, MethodObj)
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion(RME3, EmbeddedControl, 0x00, 0xFF)
        Method(_REG, 2)
        {
            XREG(Arg0, Arg1) // call original _REG, now renamed XREG
            If (3 == Arg0 && 1 == Arg1) // EC ready?
            {
                 If (CondRefOf(\RMCF.HGOF)) { \RMCF.HGOF() } // turn dedicated Nvidia fan off
            }
        }
    }
    
    // add fake ethernet device
    Device (RMNE)
    {
        Name (_ADR, Zero)
        // The NullEthernet kext matches on this HID
        Name (_HID, "NULE0000")
        // This is the MAC address returned by the kext. Modify if necessary.
        Name (MAC, Buffer() { 0x11, 0x22, 0x33, 0x44, 0x55, 0x66 })
        Method (_DSM, 4, NotSerialized)
        {
            If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "built-in", Buffer() { 0x00 },
                "IOName", "ethernet",
                "name", Buffer() { "ethernet" },
                "model", Buffer() { "RM-NullEthernet-1001" },
                "device_type", Buffer() { "ethernet" },
            })
        }
    }

    // inject USB properties
    External(_SB.PCI0.XHC, DeviceObj)
    Method (_SB.PCI0.XHC._DSM, 4, NotSerialized)
    {
        If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
        Return (Package()
        {
            "subsystem-id", Buffer() { 0x2f, 0x9d, 0x00, 0x00 },
            "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
            "AAPL,current-available", 2100,
            "AAPL,current-extra", 2200,
            "AAPL,current-extra-in-sleep", 1600,
            "AAPL,device-internal", 0x02,
            "AAPL,max-port-current-in-sleep", 2100,
        })
    }
    
    // disable original HPET device (renamed to XPET)
    External(_SB.PCI0.LPCB.XPET._HID, IntObj)
    Device(SH01)
    {
        Name(_HID, "SHD10000")
        Method(_INI) { \_SB.PCI0.LPCB.XPET._HID = 0 }
    }
    
    // add alternative HPET device
    External(HPTB, FieldUnitObj)
    Device(_SB.PCI0.LPCB.HPET)
    {
        Name (_HID, EisaId ("PNP0103"))
        Name (_CID, EisaId ("PNP0C01"))
        Name (_STA, 0x0F)
        Name (BUF0, ResourceTemplate ()
        {
            IRQNoFlags () {0,8,11,15}
            Memory32Fixed (ReadWrite, 0xFED00000, 0x00000400, _Y37)
        })
        Method (_CRS, 0, Serialized)
        {
            CreateDWordField (BUF0, ^_Y37._BAS, HPT0)
            Store (HPTB, HPT0)
            Return (BUF0)
        }
    }
    
    // add SMBUS device
    Device(_SB.PCI0.SBUS.BUS0)
    {
        Name(_CID, "smbus")
        Name(_ADR, Zero)
        Device(DVL0)
        {
            Name(_ADR, 0x57)
            Name(_CID, "diagsvault")
            Method(_DSM, 4)
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return (Package() { "address", 0x57 })
            }
        }
    }
    
    // add LPC device
    External(_SB.PCI0.LPCB, DeviceObj)
    Method (_SB.PCI0.LPCB._DSM, 4, NotSerialized)
    {
        If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
        Return (Package()
        {
            "device-id",  Buffer() { 0xc1, 0x9c, 0, 0 },
            "compatible", "pci8086,9cc1",
        })
    }
    
    // macOS expect PMCR for PPMC to load correctly credit syscl
    Device (_SB.PCI0.PMCR)
    {
        Name (_ADR, 0x001F0002)
    }
    
    // inject Fake EC device
    Device(_SB.EC)
    {
        Name(_HID, "EC000000")
    }
    
    // USB power properties via USBX device
    Device(_SB.USBX)
    {
        Name(_ADR, 0)
        Method (_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                // these values from MacBookPro14,1
                "kUSBSleepPortCurrentLimit", 0x0BB8, 
                "kUSBWakePortCurrentLimit", 0x0BB8
            })
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif