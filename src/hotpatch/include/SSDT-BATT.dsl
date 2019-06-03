// Patch by hieplpvip - Credit Rehabman
// https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.232986/

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "batt", 0)
{
#endif
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.BAT0, DeviceObj)
    External(MBLF, IntObj)
    
    // add method B1B2
    Method (B1B2, 2)
    {
        Return (Arg0 | (Arg1<<8))
    }
    
    Scope (_SB.PCI0.LPCB.EC0) {
        External(ECAV, MethodObj)
        External(BSLF, IntObj)
        External(RDBL, IntObj)
        External(RDWD, IntObj)
        External(RDBT, IntObj)
        External(RCBT, IntObj)
        External(RDQK, IntObj)
        External(MUEC, MutexObj)
        External(PRTC, FieldUnitObj)
        External(SBBY, IntObj)
        External(ADDR, FieldUnitObj)
        External(CMDB, FieldUnitObj)
        External(SWTC, MethodObj)
        External(BCNT, FieldUnitObj)
        External(DAT0, FieldUnitObj)
        External(WRBL, IntObj)
        External(WRWD, IntObj)
        External(WRBT, IntObj)
        External(SDBT, IntObj)
        External(WRQK, IntObj)
        External(BATP, MethodObj)
        External(GBTT, MethodObj)
        External(ACAP, MethodObj)
        External(CHGS, MethodObj)
        External(BRAH, FieldUnitObj)
        External(EB0S, FieldUnitObj)
        External(B0DV, FieldUnitObj)
        External(BLLO, IntObj)
        
        // add EC fields
        OperationRegion (XCOR, EmbeddedControl, 0x00, 0xFF)
        Field (XCOR, ByteAcc, Lock, Preserve)
        {
            Offset (0x93), 
            TH00,   8, 
            TH01,   8, 
            Offset (0xC4), 
            XC30, 8, 
            XC31, 8, 
            Offset (0xF4), 
            B0S0, 8, 
            B0S1, 8, 
            Offset (0xFC),
            B1S0, 8, 
            B1S1, 8
        }
        
        OperationRegion (XSMX, EmbeddedControl, 0x18, 0x28)
        Field (XSMX, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            BA00,8,BA01,8,BA02,8,BA03,8,
            BA04,8,BA05,8,BA06,8,BA07,8,
            BA08,8,BA09,8,BA0A,8,BA0B,8,
            BA0C,8,BA0D,8,BA0E,8,BA0F,8,
            BA10,8,BA11,8,BA12,8,BA13,8,
            BA14,8,BA15,8,BA16,8,BA17,8,
            BA18,8,BA19,8,BA1A,8,BA1B,8,
            BA1C,8,BA1D,8,BA1E,8,BA1F,8, 
        }
        
        Field (XSMX, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            T2B0, 8, 
            T2B1, 8
        }
        
        // add method RDBA
        Method (RDBA, 0, Serialized)
        {
            Name (TEMP, Buffer(0x20) { })
            TEMP [0x00] = BA00
            TEMP [0x01] = BA01
            TEMP [0x02] = BA02
            TEMP [0x03] = BA03
            TEMP [0x04] = BA04
            TEMP [0x05] = BA05
            TEMP [0x06] = BA06
            TEMP [0x07] = BA07
            TEMP [0x08] = BA08
            TEMP [0x09] = BA09
            TEMP [0x0A] = BA0A
            TEMP [0x0B] = BA0B
            TEMP [0x0C] = BA0C
            TEMP [0x0D] = BA0D
            TEMP [0x0E] = BA0E
            TEMP [0x0F] = BA0F
            TEMP [0x10] = BA10
            TEMP [0x11] = BA11
            TEMP [0x12] = BA12
            TEMP [0x13] = BA13
            TEMP [0x14] = BA14
            TEMP [0x15] = BA15
            TEMP [0x16] = BA16
            TEMP [0x17] = BA17
            TEMP [0x18] = BA18
            TEMP [0x19] = BA19
            TEMP [0x1A] = BA1A
            TEMP [0x1B] = BA1B
            TEMP [0x1C] = BA1C
            TEMP [0x1D] = BA1D
            TEMP [0x1E] = BA1E
            TEMP [0x1F] = BA1F
            Return (TEMP)
        }
        
        // add method WRBA
        Method (WRBA, 1, Serialized)
        {
            Name (TEMP, Buffer(0x20) { })
            TEMP = Arg0
            BA00 = DerefOf(TEMP [0x00])
            BA01 = DerefOf(TEMP [0x01])
            BA02 = DerefOf(TEMP [0x02])
            BA03 = DerefOf(TEMP [0x03])
            BA04 = DerefOf(TEMP [0x04])
            BA05 = DerefOf(TEMP [0x05])
            BA06 = DerefOf(TEMP [0x06])
            BA07 = DerefOf(TEMP [0x07])
            BA08 = DerefOf(TEMP [0x08])
            BA09 = DerefOf(TEMP [0x09])
            BA0A = DerefOf(TEMP [0x0A])
            BA0B = DerefOf(TEMP [0x0B])
            BA0C = DerefOf(TEMP [0x0C])
            BA0D = DerefOf(TEMP [0x0D])
            BA0E = DerefOf(TEMP [0x0E])
            BA0F = DerefOf(TEMP [0x0F])
            BA10 = DerefOf(TEMP [0x10])
            BA11 = DerefOf(TEMP [0x11])
            BA12 = DerefOf(TEMP [0x12])
            BA13 = DerefOf(TEMP [0x13])
            BA14 = DerefOf(TEMP [0x14])
            BA15 = DerefOf(TEMP [0x15])
            BA16 = DerefOf(TEMP [0x16])
            BA17 = DerefOf(TEMP [0x17])
            BA18 = DerefOf(TEMP [0x18])
            BA19 = DerefOf(TEMP [0x19])
            BA1A = DerefOf(TEMP [0x1A])
            BA1B = DerefOf(TEMP [0x1B])
            BA1C = DerefOf(TEMP [0x1C])
            BA1D = DerefOf(TEMP [0x1D])
            BA1E = DerefOf(TEMP [0x1E])
            BA1F = DerefOf(TEMP [0x1F])
        }
        
        //override method BIFA
        Method (BIFA, 0)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Local0 = B1B2(B1S0,B1S1)
                }
                Else
                {
                    Local0 = B1B2(B0S0,B0S1)
                }
            }
            Else
            {
                Local0 = Ones
            }

            Return (Local0)
        }
        
        // override method SMBR
        Method (SMBR, 3, Serialized)
        {
            Local0 = Package (0x03)
                {
                    0x07, 
                    0x00, 
                    0x00
                }
            If (!ECAV ())
            {
                Return (Local0)
            }

            If (Arg0 != RDBL)
            {
                If (Arg0 != RDWD)
                {
                    If (Arg0 != RDBT)
                    {
                        If (Arg0 != RCBT)
                        {
                            If (Arg0 != RDQK)
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Local1 = PRTC
            Local2 = 0
            While (Local1 != 0)
            {
                Stall (0x0A)
                Local2++
                If (Local2 > 0x03E8)
                {
                    Local0 [0] = SBBY
                    Local1 = 0
                }
                Else
                {
                    Local1 = PRTC
                }
            }

            If (Local2 <= 0x03E8)
            {
                Local3 = (Arg1 << 1) | 1
                ADDR = Local3
                If (Arg0 != RDQK)
                {
                    If (Arg0 != RCBT)
                    {
                        CMDB = Arg2
                    }
                }

                WRBA(0)
                PRTC = Arg0
                Local0 [0] = SWTC (Arg0)
                If (DerefOf (Local0 [0]) == 0)
                {
                    If (Arg0 == RDBL)
                    {
                        Local0 [1] = BCNT
                        Local0 [2] = RDBA()
                    }

                    If (Arg0 == RDWD)
                    {
                        Local0 [1] = 2
                        Local0 [2] = B1B2(T2B0,T2B1)
                    }

                    If (Arg0 == RDBT)
                    {
                        Local0 [1] = 1
                        Local0 [2] = DAT0
                    }

                    If (Arg0 == RCBT)
                    {
                        Local0 [1] = 1
                        Local0 [2] = DAT0
                    }
                }
            }

            Release (MUEC)
            Return (Local0)
        }
        
        // override method SMBW
        Method (SMBW, 5, Serialized)
        {
            Local0 = Package (0x01)
                {
                    0x07
                }
            If (!ECAV ())
            {
                Return (Local0)
            }

            If (Arg0 != WRBL)
            {
                If (Arg0 != WRWD)
                {
                    If (Arg0 != WRBT)
                    {
                        If (Arg0 != SDBT)
                        {
                            If (Arg0 != WRQK)
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Local1 = PRTC
            Local2 = 0
            While (Local1 != 0)
            {
                Stall (0x0A)
                Local2++
                If (Local2 > 0x03E8)
                {
                    Local0 [0] = SBBY
                    Local1 = 0
                }
                Else
                {
                    Local1 = PRTC
                }
            }

            If (Local2 <= 0x03E8)
            {
                WRBA(0)
                Local3 = Arg1 << 1
                ADDR = Local3
                If (Arg0 != WRQK)
                {
                    If (Arg0 != SDBT)
                    {
                        CMDB = Arg2
                    }
                }

                If (Arg0 == WRBL)
                {
                    BCNT = Arg3
                    WRBA(Arg4)
                }

                If (Arg0 == WRWD)
                {
                    T2B0 = Arg4
                    T2B1 = Arg4>>8
                }

                If (Arg0 == WRBT)
                {
                    DAT0 = Arg4
                }

                If (Arg0 == SDBT)
                {
                    DAT0 = Arg4
                }

                PRTC = Arg0
                Local0 [0] = SWTC(Arg0)
            }

            Release (MUEC)
            Return (Local0)
        }
        
        Scope (BAT0) {
            External(NBIX, PkgObj)
            External(PBIF, PkgObj)
            External(BIXT, PkgObj)
            External(_BIF, MethodObj)
            External(PBST, PkgObj)
            External(PUNT, IntObj)
            External(LFCC, IntObj)
                        
            // override method _BIX
            Method (_BIX, 0)
            {
                If (!^^BATP (0))
                {
                    Return (NBIX)
                }

                If (^^GBTT (0) == 0xFF)
                {
                    Return (NBIX)
                }

                _BIF ()
                BIXT [0x01] = DerefOf (PBIF [0x00])
                BIXT [0x02] = DerefOf (PBIF [0x01])
                BIXT [0x03] = DerefOf (PBIF [0x02])
                BIXT [0x04] = DerefOf (PBIF [0x03])
                BIXT [0x05] = DerefOf (PBIF [0x04])
                BIXT [0x06] = DerefOf (PBIF [0x05])
                BIXT [0x07] = DerefOf (PBIF [0x06])
                BIXT [0x0E] = DerefOf (PBIF [0x07])
                BIXT [0x0F] = DerefOf (PBIF [0x08])
                BIXT [0x10] = DerefOf (PBIF [0x09])
                BIXT [0x11] = DerefOf (PBIF [0x0A])
                BIXT [0x12] = DerefOf (PBIF [0x0B])
                BIXT [0x13] = DerefOf (PBIF [0x0C])
                If (DerefOf (BIXT [0x01]) == 1)
                {
                    BIXT [0x01] = 0
                    Local0 = DerefOf (BIXT [0x05])
                    BIXT [0x02] = (DerefOf (BIXT [0x02]) * Local0)
                    BIXT [0x03] = (DerefOf (BIXT [0x03]) * Local0)
                    BIXT [0x06] = (DerefOf (BIXT [0x06]) * Local0)
                    BIXT [0x07] = (DerefOf (BIXT [0x07]) * Local0)
                    BIXT [0x0E] = (DerefOf (BIXT [0x0E]) * Local0)
                    BIXT [0x0F] = (DerefOf (BIXT [0x0F]) * Local0)
                    Divide (DerefOf (BIXT [0x02]), 0x03E8, Local0, BIXT [0x02])
                    Divide (DerefOf (BIXT [0x03]), 0x03E8, Local0, BIXT [0x03])
                    Divide (DerefOf (BIXT [0x06]), 0x03E8, Local0, BIXT [0x06])
                    Divide (DerefOf (BIXT [0x07]), 0x03E8, Local0, BIXT [0x07])
                    Divide (DerefOf (BIXT [0x0E]), 0x03E8, Local0, BIXT [0x0E])
                    Divide (DerefOf (BIXT [0x0F]), 0x03E8, Local0, BIXT [0x0F])
                }

                BIXT [0x08] = B1B2(^^XC30,^^XC31)
                BIXT [0x09] = 0x0001869F
                Return (BIXT)
            }
            
            // override method FBST
            Method (FBST, 4)
            {
                Local1 = Arg1 & 0xFFFF
                Local0 = 0
                If (^^ACAP ())
                {
                    Local0 = 1
                }

                If (Local0)
                {
                    If (^^CHGS (0))
                    {
                        Local0 = 2
                    }
                    Else
                    {
                        Local0 = 1
                    }
                }
                Else
                {
                    Local0 = 1
                }

                If (^^BLLO)
                {
                    Local2 = 4
                    Local0 |= Local2
                }

                ^^BRAH = 9
                If (^^EB0S & 8)
                {
                    Local2 = 4
                    Local0 |= Local2
                }

                If (Local1 >= 0x8000)
                {
                    Local1 = 0xFFFF - Local1
                }

                Local2 = Arg2
                If (PUNT == 0)
                {
                    ^^BRAH = 9
                    Local1 *= ^^B0DV
                    Local2 *= 0x0A
                }

                Local3 = Local0 & 2
                If (!Local3)
                {
                    Local3 = LFCC - Local2
                    Divide (LFCC, 0xC8, Local4, Local5)
                    If (Local3 < Local5)
                    {
                        Local2 = LFCC
                    }
                }
                Else
                {
                    Divide (LFCC, 0xC8, Local4, Local5)
                    Local4 = (LFCC - Local5)
                    If (Local2 > Local4)
                    {
                        Local2 = Local4
                    }
                }

                If (!^^ACAP ())
                {
                    Divide (Local2, MBLF, Local3, Local4)
                    If (Local1 < Local4)
                    {
                        Local1 = Local4
                    }
                }

                PBST [0] = Local0
                PBST [1] = Local1
                PBST [2] = Local2
                PBST [3] = Arg3
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif