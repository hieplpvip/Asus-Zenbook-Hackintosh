Files created by make_acpi.sh and make_config.sh

*** acpi folder consists of:

ux303-broadwell: patched acpi files for UX303 (Broadwell)

ux310-kabylake: patched acpi files for UX310 (KabyLake)

ux330-kabylake: patched acpi files for UX330 (KabyLake)

ux330-kabylaker: patched acpi files for UX330 (KabyLake-R)

ux410-kabylake: patched acpi files for UX410 (KabyLake)

ux430-kabylake: patched acpi files for UX430 (KabyLake)

ux430-kabylaker: patched acpi files for UX430 (KabyLake-R)

SSDT-FAN-READ.aml: allows HWMonitor to read System Fan speed and CPU heatsink

SSDT-FAN-MOD.aml: FAN-READ + custom FAN control (quietest yet coolest)

SSDT-ELAN.aml: used if your laptop support VoodooI2C Interrupt Mode. If you want to use this, enable these 2 patch in config.plist: "change Method(_STA,0,NS) in GPI0 to XSTA" and "change Method(_CRS,0,S) in ETPD to XCRS".

Choose the files you need and copy them to /EFI/CLOVER/ACPI/patched

*** config folder consists of:

config_ux303_broadwell.plist: UX303 (Broadwell)

config_ux310_kabylake.plist: UX310 (KabyLake)

config_ux330_kabylake.plist: UX330 (KabyLake)

config_ux330_kabylaker.plist: UX330 (KabyLake-R)

config_ux410_kabylake.plist: UX410 (KabyLake)

config_ux430_kabylake.plist: UX430 (KabyLake)

config_ux430_kabylaker.plist: UX430 (KabyLake-R)

Rename the file for your laptop to 'config.plist' and copy it to /EFI/CLOVER
Remember to backup SMBIOS