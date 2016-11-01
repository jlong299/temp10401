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
vlog -sv ../../src/RAM_FIFO/RAM_dct_vecRot/ram_2port_151/sim/RAM_dct_vecRot_ram_2port_151_byb7zvy.v
vlog -sv ../../src/dct_vecRot_twiddle.v 
vlog -sv ../../src/dct_vecRot_scaling.v 
vlog -sv ../../src/dct_vecRot_coeff.v 
vlog -sv ../../src/RAM_FIFO/ROM_cos_dct_vecRot/sim/ROM_cos_dct_vecRot.v
vlog -sv ../../src/RAM_FIFO/ROM_cos_dct_vecRot/rom_1port_151/sim/ROM_cos_dct_vecRot_rom_1port_151_gip373i.v
vlog -sv ../../src/RAM_FIFO/ROM_sin_dct_vecRot/sim/ROM_sin_dct_vecRot.v
vlog -sv ../../src/RAM_FIFO/ROM_sin_dct_vecRot/rom_1port_151/sim/ROM_sin_dct_vecRot_rom_1port_151_xhfa2qa.v
vlog -sv ../../src/dct_vecRot.v 
vlog -sv ../../src/RAM_FIFO/RAM_dct_preFFT_reod/sim/RAM_dct_preFFT_reod.v
vlog -sv ../../src/RAM_FIFO/RAM_dct_preFFT_reod/ram_2port_151/sim/RAM_dct_preFFT_reod_ram_2port_151_nn5gxoa.v
vlog -sv ../../src/dct_preFFT_reod.v 
vlog -sv ../../src/dct_top.v 

# Elaborate the design.
elab
# Run the simulation

view wave
add wave *
add wave sim:/dct_fft_tb/u0/*
# add wave sim:/dct_fft_tb/u0/dct_preFFT_reod_inst/*
view structure
view signals
run 200us
# Report success to the shell
# exit -code 0
# End of template
# ----------------------------------------