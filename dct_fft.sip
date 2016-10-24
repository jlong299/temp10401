set_global_assignment -entity "dct_fft" -library "lib_dct_fft" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "dct_fft" -library "lib_dct_fft" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "dct_fft" -library "lib_dct_fft" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_dct_fft" -name SPD_FILE [file join $::quartus(sip_path) "dct_fft.spd"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "../dct_fft.qsys"]

set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "sim/dct_fft.v"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twr2.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twi3.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twr3.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twi4.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twi1.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twr4.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twi5.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twr1.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twr5.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i_opt_twi2.hex"]
set_global_assignment -library "lib_dct_fft" -name MISC_FILE [file join $::quartus(sip_path) "altera_fft_ii_151/sim/dct_fft_altera_fft_ii_151_lnky34i.vo"]
