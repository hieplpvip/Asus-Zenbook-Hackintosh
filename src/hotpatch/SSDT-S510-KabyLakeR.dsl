// SSDT for VivoBook S510 (Kabylake-R)

DefinitionBlock ("", "SSDT", 2, "hack", "s510klr", 0)
{
    #define NO_DEFINITIONBLOCK
    
    // audio
    #include "include/SSDT-CX8050.dsl"
    #include "include/layout3_HDEF.asl"
    
    // battery
    #include "include/SSDT-BATT.dsl"
    
    // keyboard backlight/fn keys/fake als
    #include "include/SSDT-ATK-KABY.dsl"
    #include "include/SSDT-ALS0.dsl"
    
    // backlight
    #include "include/SSDT-PNLF.dsl"
    
    // disable DGPU
    //#include "include/SSDT-RP01_PEGP.dsl"
    
    // usb
    #include "include/SSDT-XHC.dsl"
    #include "include/SSDT-USBX.dsl"
    
    // others
    #include "include/SSDT-HACK.dsl"
    #include "include/SSDT-PTSWAK.dsl"
    #include "include/SSDT-LPC.dsl"
    #include "include/SSDT-IGPU.dsl"
}