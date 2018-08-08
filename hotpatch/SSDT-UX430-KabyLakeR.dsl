// SSDT for Zenbook UX430 (Kabylake-R)

DefinitionBlock ("", "SSDT", 2, "hack", "ux430klr", 0)
{
    #define NO_DEFINITIONBLOCK
    #include "include/layout13_HDEF.asl"
    #include "include/SSDT-ATK-KABY.dsl"
    #include "include/SSDT-BATT.dsl"
    #include "include/SSDT-HACK.dsl"
    #include "include/SSDT-PNLF.dsl"
    #include "include/SSDT-PTSWAK.dsl"
    #include "include/SSDT-RP01_PEGP.dsl"
    #include "include/SSDT-AppleALC.dsl"
    #include "include/SSDT-UIAC-UX430-KABYR.dsl"
}