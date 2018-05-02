DefinitionBlock ("SSDT-ALS", "SSDT", 2, "hack", "als", 0)
{
 	External(_SB.PCI0.LPCB.EC0, DeviceObj)
	External(_SB.PCI0.LPCB.EC0.RALS, MethodObj)
	External(_SB.ALS, DeviceObj)
	External(ATKP, IntObj)
	External(_SB.ATKD, DeviceObj)	
	External(_SB.ATKD.IANE, MethodObj)

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
			If (ATKP)
			{
				\RMDT.P2("ALS sensor:", ^^^^ATKD.ALSS())
				Notify(ALS, 0x80)
				^^^^ATKD.IANE (0xC6)
			}
		}
	}

	
	Scope (_SB.ATKD)
	{
       	Method (ALSS, 0, NotSerialized)
        {
            	Return (^^PCI0.LPCB.EC0.RALS ())
        }
	}
}
	
