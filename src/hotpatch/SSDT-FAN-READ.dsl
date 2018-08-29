// SSDT for FAN readings for ASUS laptops

// Copyright, black.dragon74 <www.osxlatitude.com>

DefinitionBlock("", "SSDT", 2, "hack", "fan", 0)
{
    // Declare externals
    External (\_SB.PCI0.LPCB.EC0.ECAV, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.ECPU, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.ST83, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.TACH, MethodObj)

    // Create devices required by FakeSMC_ACPISensors
    Device (SMCD)
    {
        Name (_HID, "FAN00000") // Required, DO NOT change
        
        // Add tachometer
        Name (TACH, Package()
        {
            "System Fan", "FAN0"
        })
        
        // Add CPU heatsink
        Name (TEMP, Package()
        {
            "CPU Heatsink", "TCPU"
        })
        
        // Method to read FAN RPM (tachometer)
        Method (FAN0, 0)
        {
            // Check is EC is ready
            If (\_SB.PCI0.LPCB.EC0.ECAV())
            {
                Local0 = \_SB.PCI0.LPCB.EC0.ST83(0) // Method ST83 acquires mutex and writes value to EC. O stands for FAN 1, Use 1 for FAN 2
                If (Local0 == 255)
                {
                    // If ST83 is 0xFF (Max fan speed) terminate by returning FAN RPM
                    Return (Local0)
                }
                // Else, Get RPM and store it in Local0
                Local0 = \_SB.PCI0.LPCB.EC0.TACH(0) // Method TACH in DSDT returns current FAN RPM in 100s, Arg0 as 0 is for FAN 1, for FAN 2, use Arg0 as 1
                    
            }
            Else
            {
                // Terminate, return Zero
                Local0 = 0
            }
            
            // Return 255, 0 or Fan RPM based on conditionals above
            Return (Local0)  
        }
        
        // Method to read CPU temp (CPU Heatsink)
        Method (TCPU, 0)
        {
            // Check if EC is ready
            If (\_SB.PCI0.LPCB.EC0.ECAV())
            {
                // Then
                Local0 = \_SB.PCI0.LPCB.EC0.ECPU // EC Field storing current CPU temp
                Local1 = 60 // From DSDT
                
                If (Local0 < 128)
                {
                    Local1 = Local0
                }
                
            }
            Else
            {
                // Terminate, return Zero
                Local1 = 0
            }
        
            // Return final CPU temp. ACPISensors take care of unit conversion.
            Return (Local1)
        }
    }
}    