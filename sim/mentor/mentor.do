# ----------------------------------------
# Auto-generated simulation script msim_setup.tcl
# ----------------------------------------
# This script can be used to simulate the following IP:
#     dct_fft
# To create a top-level simulation script which compiles other
# IP, and manages other system issues, copy the following template
# and adapt it to your needs:
# 
# # Start of template
# If the copied and modified template file is "mentor.do", run it as:
#   vsim -c -do mentor.do
#
# Source the generated sim script
source msim_setup.tcl
# Compile eda/sim_lib contents first
dev_com
# Override the top-level name (so that elab is useful)
set TOP_LEVEL_NAME dct_fft_tb
# Compile the standalone IP.
com
# Compile the user top-level
vlog -sv ../../tb/dct_fft_tb.v
vlog -sv ../../src/dct_vecRot_ram.v 
vlog -sv ../../src/RAM_FIFO/RAM_dct_vecRot/sim/RAM_dct_vecRot.v
vlog -sv ../../src/RAM_FIFO/RAM_dct_vecRot/ram_2port_151/sim/RAM_dct_vecRot_ram_2port_151_65vwdsi.v
# Elaborate the design.
elab
# Run the simulation

view wave
add wave *
add wave sim:/dct_fft_tb/dct_vecRot_ram_inst/*
view structure
view signals
run 70us
# Report success to the shell
# exit -code 0
# End of template
# ----------------------------------------