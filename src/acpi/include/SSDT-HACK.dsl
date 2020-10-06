#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "HIEP", "HACK", 0)
{
#endif
    // All _OSI calls in DSDT are routed to XOSI...
    // As written, this XOSI simulates "Windows 2015" (which is Windows 10)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    //       Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        // simulation targets
        // source: (google 'Microsoft Windows _OSI')
        //         https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi
        Local0 = Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP1",     // Windows XP SP1
            "Windows 2001 SP2",     // Windows XP SP2
            "Windows 2001.1",       // Windows Server 2003
            "Windows 2001.1 SP1",   // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            "Windows 2006.1",       // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            "Windows 2013",         // Windows 8.1/Windows Server 2012 R2
            "Windows 2015",         // Windows 10/Windows Server TP
            "Windows 2016",         // Windows 10, version 1607
            "Windows 2017",         // Windows 10, version 1703
            "Windows 2017.2",       // Windows 10, version 1709
            "Windows 2018",         // Windows 10, version 1803
            "Windows 2018.2",       // Windows 10, version 1809
            "Windows 2019",         // Windows 10, version 1903
        }
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }

    // In DSDT, native GPRW is renamed to XPRW with Clover binpatch.
    // As a result, calls to GPRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return(Package() { 0x6d, 0, }) }
        If (0x0d == Arg0) { Return(Package() { 0x0d, 0, }) }
        External(\XPRW, MethodObj)
        Return(XPRW(Arg0, Arg1))
    }

    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XREG, MethodObj)
    External(RMD1.HGOF, MethodObj)
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion(RME3, EmbeddedControl, 0x00, 0xFF)
        Method(_REG, 2)
        {
            XREG(Arg0, Arg1) // call original _REG, now renamed XREG
            If (3 == Arg0 && 1 == Arg1) // EC ready?
            {
                If (CondRefOf(\RMD1.HGOF)) { \RMD1.HGOF(1) }
            }
        }
    }

    // add fake EC device
    Device(_SB.EC)
    {
        Name(_HID, "EC000000")
    }

    // add SMBUS device
    External(_SB.PCI0.SBUS, DeviceObj)
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

    // macOS expect PMCR for PPMC to load correctly credit syscl
    Device (_SB.PCI0.PMCR)
    {
        Name (_ADR, 0x001F0002)
    }

    // add missing Memory (DRAM) Controller
    Device (_SB.PCI0.MCHC)
    {
        Name (_ADR, Zero)
    }

    // add missing DMA controller
    Device (_SB.PCI0.LPCB.DMAC)
    {
        Name (_HID, EisaId("PNP0200"))
        Name (_CRS, ResourceTemplate ()
        {
            IO (Decode16, 0x00, 0x00, 0x01, 0x20)
            IO (Decode16, 0x81, 0x81, 0x01, 0x11)
            IO (Decode16, 0x93, 0x93, 0x01, 0x0D)
            IO (Decode16, 0xC0, 0xC0, 0x01, 0x20)
            DMA (Compatibility, NotBusMaster, Transfer8_16) {4}
        })
    }

    // This exist on real Mac, seems to defines a fixed memory region for IGPU
    Device (MEM2)
    {
        Name (_HID, EisaId("PNP0C01"))
        Name (_UID, 0x02)
        Name (CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite, 0x20000000, 0x00200000)
            Memory32Fixed (ReadWrite, 0x40000000, 0x00200000)
        })
        Method (_CRS, 0)
        {
            Return (CRS)
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
