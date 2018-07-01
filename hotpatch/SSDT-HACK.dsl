#define SANDYIVY_PWMMAX 0x710
#define HASWELL_PWMMAX 0xad9
#define SKYLAKE_PWMMAX 0x56c
#define CUSTOM_PWMMAX_07a1 0x07a1
#define CUSTOM_PWMMAX_1499 0x1499
DefinitionBlock ("SSDT-HACK", "SSDT", 2, "hack", "hack", 0)
{
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
    
    // disable the discrete GPU 
    External(_SB.PCI0.RP01.PEGP._OFF, MethodObj)
    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        Method(_INI)
        {
            If (CondRefOf(\_SB.PCI0.RP01.PEGP._OFF)) { \_SB.PCI0.RP01.PEGP._OFF() }
        }
    }
    
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XREG, MethodObj)
    External(_SB.PCI0.HGOF, MethodObj)
    Scope(_SB.PCI0.LPCB.EC0)
    {
        OperationRegion(RME3, EmbeddedControl, 0x00, 0xFF)
        Method(_REG, 2)
        {
            XREG(Arg0, Arg1) // call original _REG, now renamed XREG
            If (3 == Arg0 && 1 == Arg1) // EC ready?
            {
                 \_SB.PCI0.HGOF() // turn dedicated Nvidia fan off
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
    Device(_SB.PCI0.LPCB.HPET)
    {
        Name (_HID, EisaId ("PNP0103"))
        Name (_CID, EisaId ("PNP0C01"))
        Name (_STA, 0x0F)
        Name (_CRS, ResourceTemplate ()
        {
            IRQNoFlags () {0,8,11,15}
            Memory32Fixed (ReadWrite, 0xFED00000, 0x00000400)
        })
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
    
    // enable keyboard backlight
    External(_SB.ATKD, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
    External(_SB.PCI0.LPCB.EC0.ST9E, MethodObj)
    External(_SB.KBLV, FieldUnitObj)
    Scope (_SB.ATKD)
    {
        Name (BOFF, Zero)
        Method (SKBL, 1, NotSerialized)
        {
            If (Or (LEqual (Arg0, 0xED), LEqual (Arg0, 0xFD)))
            {
                If (And (LEqual (Arg0, 0xED), LEqual (BOFF, 0xEA)))
                {
                    Store (Zero, Local0)
                    Store (Arg0, BOFF)
                }
                ElseIf (And (LEqual (Arg0, 0xFD), LEqual (BOFF, 0xFA)))
                {
                    Store (Zero, Local0)
                    Store (Arg0, BOFF)
                }
                Else
                {
                    Return (BOFF)
                }
            }
            ElseIf (Or (LEqual (Arg0, 0xEA), LEqual (Arg0, 0xFA)))
            {
                Store (Arg0, BOFF)
            }
            Else
            {
                Store (And (Arg0, 0x7F), KBLV)
            }
            
            // **Customizable part
            // from method SLKB
            Store (0x0900, Local0)
            Add (Local0, 0xF0, Local0)
            ^^PCI0.LPCB.EC0.WRAM (Local0, ^^KBLV)
            Store (DerefOf (Index (PWKB, ^^KBLV)), Local0)
            ^^PCI0.LPCB.EC0.ST9E (0x1F, 0xFF, Local0)
            // Customizable part**
            Return (Local0)
        }
        
        Name (PWKB, Buffer (0x04)
        {
             0x00, 0x55, 0xAA, 0xFF                         
        })
        
        Method (GKBL, 1, NotSerialized)
        {
            If (LEqual (Arg0, 0xFF))
            {
                Return (BOFF)
            }
            
            Return (KBLV)
        }
    }
    
    // Overriding _PTS and _WAK
    External(ZPTS, MethodObj)
    External(ZWAK, MethodObj)

    External(_SB.PCI0.RP01.PEGP._ON, MethodObj)
    External(_SB.PCI0.RP01.PEGP._OFF, MethodObj)

    External(RMCF.SHUT, IntObj)
    External(RMCF.XPEE, IntObj)
    External(RMCF.SSTF, IntObj)

    // In DSDT, native _PTS and _WAK are renamed ZPTS/ZWAK
    // As a result, calls to these methods land here.
    Method(_PTS, 1)
    {
        if (5 == Arg0)
        {
            // Shutdown fix, if enabled
            If (CondRefOf(\RMCF.SHUT)) { If (\RMCF.SHUT) { Return } }
        }
        
        // enable discrete graphics
        If (CondRefOf(\_SB.PCI0.RP01.PEGP._ON)) { \_SB.PCI0.RP01.PEGP._ON() }

        // call into original _PTS method
        If (LNotEqual(Arg0,5)) { ZPTS(Arg0) }

        If (5 == Arg0)
        {
            // XHC.PMEE fix, if enabled
            External(\_SB.PCI0.XHC.PMEE, FieldUnitObj)
            If (CondRefOf(\RMCF.XPEE)) { If (\RMCF.XPEE && CondRefOf(\_SB.PCI0.XHC.PMEE)) { \_SB.PCI0.XHC.PMEE = 0 } }
        }
    }
    Method(_WAK, 1)
    {
        // Take care of bug regarding Arg0 in certain versions of OS X...
        // (starting at 10.8.5, confirmed fixed 10.10.2)
        If (Arg0 < 1 || Arg0 > 5) { Arg0 = 3 }

        // call into original _WAK method
        Local0 = ZWAK(Arg0)
        
        // disable discrete graphics
        If (CondRefOf(\_SB.PCI0.RP01.PEGP._OFF)) { \_SB.PCI0.RP01.PEGP._OFF() }

        If (CondRefOf(\RMCF.SSTF))
        {
            If (\RMCF.SSTF)
            {
                // call _SI._SST to indicate system "working"
                // for more info, read ACPI specification
                External(\_SI._SST, MethodObj)
                If (3 == Arg0 && CondRefOf(\_SI._SST)) { \_SI._SST(1) }
            }
        }

        // return value from original _WAK
        Return (Local0)
    }
    
    // Adding PNLF device for AppleBacklight.kext+AppleBacklightInjector.kext
    External(RMCF.BKLT, IntObj)
    External(RMCF.LMAX, IntObj)
    External(RMCF.FBTP, IntObj)

    External(_SB.PCI0.IGPU, DeviceObj)
    Scope(_SB.PCI0.IGPU)
    {
        // need the device-id from PCI_config to inject correct properties
        OperationRegion(IGD5, PCI_Config, 0, 0x14)
    }

    // For backlight control
    Device(_SB.PCI0.IGPU.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        // _UID is set depending on PWMMax
        // 10: Sandy/Ivy 0x710
        // 11: Haswell/Broadwell 0xad9
        // 12: Skylake/KabyLake 0x56c (and some Haswell, example 0xa2e0008)
        // 99: Other
        Name(_UID, 0)
        Name(_STA, 0x0B)

        Field(^IGD5, AnyAcc, NoLock, Preserve)
        {
            Offset(0x02), GDID,16,
            Offset(0x10), BAR1,32,
        }

        OperationRegion(RMB1, SystemMemory, BAR1 & ~0xF, 0xe1184)
        Field(RMB1, AnyAcc, Lock, Preserve)
        {
            Offset(0x48250),
            LEV2, 32,
            LEVL, 32,
            Offset(0x70040),
            P0BL, 32,
            Offset(0xc8250),
            LEVW, 32,
            LEVX, 32,
            Offset(0xe1180),
            PCHL, 32,
        }

        Method(_INI)
        {
            // IntelBacklight.kext takes care of this at load time...
            // If RMCF.BKLT does not exist, it is assumed you want to use AppleBacklight.kext...
            If (CondRefOf(\RMCF.BKLT)) { If (1 != \RMCF.BKLT) { Return } }

            // Adjustment required when using AppleBacklight.kext
            Local0 = GDID
            Local2 = Ones
            If (CondRefOf(\RMCF.LMAX)) { Local2 = \RMCF.LMAX }
            // Determine framebuffer type (for PWM register layout)
            Local3 = 0
            If (CondRefOf(\RMCF.FBTP)) { Local3 = \RMCF.FBTP }
            If (0 == Local3)
            {
                If (Ones != Match(Package()
                    {
                        // Sandy HD3000
                        0x010b, 0x0102,
                        0x0106, 0x1106, 0x1601, 0x0116, 0x0126,
                        0x0112, 0x0122,
                        // Ivy
                        0x0152, 0x0156, 0x0162, 0x0166,
                        0x016a,
                        // Arrandale
                        0x0046, 0x0042,
                    }, MEQ, Local0, MTR, 0, 0))
                {
                    Local3 = 1
                }
                Else
                {
                    // otherwise... Assume Haswell/Broadwell/Skylake
                    Local3 = 2
                }
            }

            // Local3 is now framebuffer type, depending on RMCF.FBTP or device-id detect
            If (1 == Local3)
            {
                // Sandy/Ivy
                if (Ones == Local2) { Local2 = SANDYIVY_PWMMAX }

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMMax but retain current backlight level by scaling
                    Local0 = (LEVL * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    Local3 = Local2 << 16
                    If (Local2 > Local1)
                    {
                        // PWMMax is getting larger... store new PWMMax first
                        LEVX = Local3
                        LEVL = Local0
                    }
                    Else
                    {
                        // otherwise, store new brightness level, followed by new PWMMax
                        LEVL = Local0
                        LEVX = Local3
                    }
                }
            }
            ElseIf (2 == Local3) // No other values are valid for RMCF.FBTP
            {
                // otherwise... Assume Haswell/Broadwell/Skylake
                if (Ones == Local2)
                {
                    // check Haswell and Broadwell, as they are both 0xad9 (for most common ig-platform-id values)
                    If (Ones != Match(Package()
                        {
                            // Haswell
                            0x0d26, 0x0a26, 0x0d22, 0x0412, 0x0416, 0x0a16, 0x0a1e, 0x0a1e, 0x0a2e, 0x041e, 0x041a,
                            // Broadwell
                            0x0bd1, 0x0bd2, 0x0BD3, 0x1606, 0x160e, 0x1616, 0x161e, 0x1626, 0x1622, 0x1612, 0x162b,
                        }, MEQ, Local0, MTR, 0, 0))
                    {
                        Local2 = HASWELL_PWMMAX
                    }
                    Else
                    {
                        // assume Skylake/KabyLake, both 0x56c
                        // 0x1916, 0x191E, 0x1926, 0x1927, 0x1912, 0x1932, 0x1902, 0x1917, 0x191b,
                        // 0x5916, 0x5912, 0x591b, others...
                        Local2 = SKYLAKE_PWMMAX
                    }
                }

                // This 0xC value comes from looking what OS X initializes this\n
                // register to after display sleep (using ACPIDebug/ACPIPoller)\n
                LEVW = 0xC0000000

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (((LEVX & 0xFFFF) * Local2) / Local1) | (Local2 << 16)
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    LEVX = Local0
                }
            }

            // Now Local2 is the new PWMMax, set _UID accordingly
            // The _UID selects the correct entry in AppleBacklightInjector.kext
            If (Local2 == SANDYIVY_PWMMAX) { _UID = 14 }
            ElseIf (Local2 == HASWELL_PWMMAX) { _UID = 15 }
            ElseIf (Local2 == SKYLAKE_PWMMAX) { _UID = 16 }
            ElseIf (Local2 == CUSTOM_PWMMAX_07a1) { _UID = 17 }
            ElseIf (Local2 == CUSTOM_PWMMAX_1499) { _UID = 18 }
            Else { _UID = 99 }
        }
    }
}