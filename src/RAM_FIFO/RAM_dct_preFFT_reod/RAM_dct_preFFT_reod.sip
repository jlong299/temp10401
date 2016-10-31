set_global_assignment -entity "RAM_dct_preFFT_reod" -library "lib_RAM_dct_preFFT_reod" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "RAM_dct_preFFT_reod" -library "lib_RAM_dct_preFFT_reod" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "RAM_dct_preFFT_reod" -library "lib_RAM_dct_preFFT_reod" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_RAM_dct_preFFT_reod" -name SPD_FILE [file join $::quartus(sip_path) "RAM_dct_preFFT_reod.spd"]
set_global_assignment -library "lib_RAM_dct_preFFT_reod" -name MISC_FILE [file join $::quartus(sip_path) "../RAM_dct_preFFT_reod.qsys"]

set_global_assignment -library "lib_RAM_dct_preFFT_reod" -name MISC_FILE [file join $::quartus(sip_path) "sim/RAM_dct_preFFT_reod.v"]
set_global_assignment -library "lib_RAM_dct_preFFT_reod" -name MISC_FILE [file join $::quartus(sip_path) "ram_2port_151/sim/RAM_dct_preFFT_reod_ram_2port_151_nn5gxoa.v"]
