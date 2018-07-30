// SSDT for Zenbook UX430 (Kabylake)

DefinitionBlock ("", "SSDT", 2, "hack", "ux430k", 0)
{
    #define NO_DEFINITIONBLOCK
    #include "include/layout3_HDEF.asl"
    #include "include/SSDT-ATK.dsl"
    #include "include/SSDT-BATT.dsl"
    #include "include/SSDT-HACK.dsl"
    #include "include/SSDT-PNLF.dsl"
    #include "include/SSDT-PTSWAK.dsl"
    #include "include/SSDT-UIAC-UX430-KABY.dsl"
}