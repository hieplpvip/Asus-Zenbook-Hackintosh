// SSDT for Zenbook UX410 (Kabylake)

DefinitionBlock ("", "SSDT", 2, "hack", "ux410kl", 0)
{
    #define NO_DEFINITIONBLOCK
    #include "include/layout3_HDEF.asl"
    #include "include/SSDT-ATK-KABY.dsl"
    #include "include/SSDT-BATT.dsl"
    #include "include/SSDT-HACK.dsl"
    #include "include/SSDT-PNLF.dsl"
    #include "include/SSDT-PTSWAK.dsl"
    #include "include/SSDT-RP01_PEGP.dsl"
    #include "include/SSDT-CX8050.dsl"
    #include "include/SSDT-UIAC-UX410-KABY.dsl"
}