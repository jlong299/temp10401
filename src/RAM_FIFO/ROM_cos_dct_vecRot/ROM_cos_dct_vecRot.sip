set_global_assignment -entity "ROM_cos_dct_vecRot" -library "lib_ROM_cos_dct_vecRot" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "ROM_cos_dct_vecRot" -library "lib_ROM_cos_dct_vecRot" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "ROM_cos_dct_vecRot" -library "lib_ROM_cos_dct_vecRot" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_ROM_cos_dct_vecRot" -name SPD_FILE [file join $::quartus(sip_path) "ROM_cos_dct_vecRot.spd"]
set_global_assignment -library "lib_ROM_cos_dct_vecRot" -name MISC_FILE [file join $::quartus(sip_path) "../ROM_cos_dct_vecRot.qsys"]

set_global_assignment -library "lib_ROM_cos_dct_vecRot" -name MISC_FILE [file join $::quartus(sip_path) "sim/ROM_cos_dct_vecRot.v"]
set_global_assignment -library "lib_ROM_cos_dct_vecRot" -name MISC_FILE [file join $::quartus(sip_path) "rom_1port_151/sim/ROM_cos_dct_vecRot_rom_1port_151_gip373i.v"]
