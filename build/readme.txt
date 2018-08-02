ux410-kabylake: patched acpi files for UX410 (KabyLake)

ux430-kabylake: patched acpi files for UX430 (KabyLake)

ux430-kabylaker: patched acpi files for UX430 (KabyLake-R)

SSDT-FAN-READ.aml: allows HWMonitor to read System Fan speed and CPU heatsink

SSDT-FAN-MOD.aml: FAN-READ + custom FAN control (quietest yet coolest)

SSDT-IGPU.aml: inject properties for Intel GPU

SSDT-ELAN.aml: used if your laptop support VoodooI2C Interrupt Mode. If you want to use this, enable these 2 patch in config.plist: "change Method(_STA,0,NS) in GPI0 to XSTA" and "change Method(_CRS,0,S) in ETPD to XCRS".