set_global_assignment -entity "RAM_dct_vecRot" -library "lib_RAM_dct_vecRot" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "RAM_dct_vecRot" -library "lib_RAM_dct_vecRot" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "RAM_dct_vecRot" -library "lib_RAM_dct_vecRot" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_RAM_dct_vecRot" -name SPD_FILE [file join $::quartus(sip_path) "RAM_dct_vecRot.spd"]
set_global_assignment -library "lib_RAM_dct_vecRot" -name MISC_FILE [file join $::quartus(sip_path) "../RAM_dct_vecRot.qsys"]

set_global_assignment -library "lib_RAM_dct_vecRot" -name MISC_FILE [file join $::quartus(sip_path) "sim/RAM_dct_vecRot.v"]
set_global_assignment -library "lib_RAM_dct_vecRot" -name MISC_FILE [file join $::quartus(sip_path) "ram_2port_151/sim/RAM_dct_vecRot_ram_2port_151_byb7zvy.v"]
