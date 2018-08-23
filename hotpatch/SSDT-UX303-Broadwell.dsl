// SSDT for Zenbook UX310 (Kabylake)

DefinitionBlock ("", "SSDT", 2, "hack", "ux303bdw", 0)
{
    #define NO_DEFINITIONBLOCK
    
    // audio
    #include "include/SSDT-CX207512.dsl"
    #include "include/layout28_HDEF.asl"
    
    // battery
    #include "include/SSDT-BATT.dsl"
    
    // fn keys
    #include "include/SSDT-ATK-BDW.dsl"
    
    // backlight
    #include "include/SSDT-PNLF.dsl"
    
    // disable DGPU
    //#include "include/SSDT-RP01_PEGP.dsl"
    
    // usb
    #include "include/SSDT-XHC.dsl"
    #include "include/SSDT-USBX.dsl"
    //#include "include/SSDT-UIAC-UX303-BDW.dsl"
    
    // others
    #include "include/SSDT-HACK.dsl"
    #include "include/SSDT-PTSWAK.dsl"
    #include "include/SSDT-LPC.dsl"
    #include "include/SSDT-IGPU.dsl"
}