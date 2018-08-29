// SSDT for FAN readings and custom FAN control for ASUS laptops

// Copyright, black.dragon74 <www.osxlatitude.com>

// Please configure the options in Device ANKD before compiling this SSDT

DefinitionBlock("", "SSDT", 2, "hack", "fan", 0)
{
    // Declare externals
    External (\_SB.PCI0.LPCB.EC0.ECAV, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.ECPU, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.ST83, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.ST98, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.TACH, MethodObj)


    // Create a Nick's device to take care of this SSDT's configurations
    Device (ANKD)
    {
        Name (_HID, "ANKD0000") // Required. DO NOT change
        Name (UCFC, 1) // Set this to 0 if you don't wanna use my custom FAN control
    }

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
        
        // Custom FAN table by black.dragon74 for ASUS laptops based on RehabMan's idea
        // Quietest fan operation yet coolest CPU.
        // Scaling from values as low as 255 RPM to values as high as 5026 RPM (That's great!)
        // Scaling that ASUS provided was from 2200 RPM to 2900 RPM (Duh!)
        
        // Temperatures. 0xFF means if temp is above 52C, let bios take control of things(auto).
        Name(FTA1, Package()
        {
            32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 0xFF,
        })
        
        // Fan speeds. 255(0xFF) is max/auto, 0(0x00) is for fan off
        Name(FTA2, Package()
        {
            0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 160, 185, 205, 225, 245, 250, 255
        })
        
        // Time out values
        Name (FCTU, 2) // RPM Up
        Name (FCTD, 5) // RPM Down

        // Table to keep track of past temperatures (to track average)
        Name (FHST, Buffer() { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }) // Size should match the count of above FTA1 and FTA2 package
        Name (FIDX, 0) 	// current index in buffer above
        Name (FNUM, 0) 	// number of entries in above buffer to count in avg
        Name (FSUM, 0) 	// current sum of entries in buffer
        
        // Keeps track of last fan speed set, and counter to set new one
        Name (FLST, 0xFF)	    // last index for fan control
        Name (FCNT, 0)		// count of times it has been "wrong", 0 means no counter
        
        // Method to control FAN wrt TEMP
        // Name in ACPIPoller.kext's Info.plist should be FCPU with HID FAN00000
        Method (FCPU, 0)
        {            
            // If UCFC is set to 0, terminate
            If (\ANKD.UCFC == 0)
            {
                Return (0)
            }
            
            // If EC is not ready, terminate
            If (!\_SB.PCI0.LPCB.EC0.ECAV())
            {
                Return (0)
            }    
                
            Local5 = \_SB.PCI0.LPCB.EC0.ECPU // Current temperature of the CPU Heatsink
            If (Local5 < 128)
            {
                Local0 = Local5 // Store temperature in Local0
            }
            Else
            {
                Local0 = 60 // As per BIOS
            }    

            // calculate average temperature
            Local1 = Local0 + FSUM
            Local2 = FIDX
            Local1 -= DerefOf(FHST[Local2])
            FHST[Local2] = Local0
            FSUM = Local1  // Local1 is new sum
            
            // adjust current index into temperature history table
            Local2++
            if (Local2 >= SizeOf(FHST)) { Local2 = 0 }
            FIDX = Local2
            
            // adjust total items collected in temp table
            Local2 = FNUM
            if (Local2 != SizeOf(FHST))
            {
                Local2++
                FNUM = Local2
            }
            
            // Local1 is new sum, Local2 is number of entries in sum
            Local0 = Local1 / Local2 // Local0 is now average temp

            // table based search (use avg temperature to search)
            if (Local0 > 255) { Local0 = 255 }
            Local2 = Match(FTA1, MGE, Local0, MTR, 0, 0)

            // calculate difference between current and found index
            if (Local2 > FLST)
            {
                Local1 = Local2 - FLST
                Local4 = FCTU
            }
            else
            {
                Local1 = FLST - Local2
                Local4 = FCTD
            }

            // set new fan speed, if necessary
            If (!Local1)
            {
                // no difference, so leave current fan speed and reset count
                FCNT = 0
            }
            Else
            {
                // there is a difference, start/continue process of changing fan
                Local3 = FCNT
                FCNT++
                // how long to wait depends on how big the difference
                // 20 secs if diff is 2, 5 secs if diff is 4, etc.
                Local1 = Local4 / Local1
                If (Local3 >= Local1)
                {
                    // timeout expired, so start setting new fan speed
                    FLST = Local2
                    
                    // Method 1 (Recommended)
                    
                    // Store custom fan value from table in Local5
                    // Local5 = DerefOf(FTA2[Local2])
                    
                    // Set QFAN value to that of Local5
                    // \_SB.QFAN = Local5
                    
                    // Execute QMOD with Arg0 as 1(One) to set FAN's max allowed speed to that of \_SB.QFAN
                    // \_SB.ATKD.QMOD(1)
                    
                    // End Method 1
                    
                    // Method 2 (Works but not recommended) Uncomment the line below to use this (remember to comment lines in method 1)
                    
                    \_SB.PCI0.LPCB.EC0.ST98 (DerefOf(FTA2[Local2]))
                    
                    // End Method 2
                    
                    // Reset FAN count (Required in either methods)
                    FCNT = 0
                }
            }
            
            Return (1) // Return something as this is a requirement of a ACPI Method
        }
    }
}    