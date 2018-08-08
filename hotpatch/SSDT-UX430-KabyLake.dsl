// SSDT for Zenbook UX430 (Kabylake)

DefinitionBlock ("", "SSDT", 2, "hack", "ux430kl", 0)
{
    #define NO_DEFINITIONBLOCK
    #include "include/layout12_HDEF.asl"
    #include "include/SSDT-ATK-KABY.dsl"
    #include "include/SSDT-BATT.dsl"
    #include "include/SSDT-HACK.dsl"
    #include "include/SSDT-PNLF.dsl"
    #include "include/SSDT-PTSWAK.dsl"
    #include "include/SSDT-RP01_PEGP.dsl"
    #include "include/SSDT-ALC295.dsl"
    #include "include/SSDT-UIAC-UX430-KABY.dsl"
}