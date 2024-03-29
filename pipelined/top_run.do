# Create work library
vlib work

# Compile Verilog
# All Verilog files that are part of this design should have
# their own "vlog" line below.
vlog top.sv
vlog cpu.sv
vlog PC.sv
vlog shift_N_reg.sv
vlog instruction_mem.sv
vlog control.sv
vlog register_file.sv
vlog alu.sv
vlog shifter.sv
vlog branch_decider.sv
vlog data_mem.sv
vlog uart_tx.sv
vlog FIFO.sv
vlog FIFO_Control.sv
vlog imm_gen.sv
vlog forwarding_unit.sv
vlog hazard_detection_unit.sv

# Call vsim to invoke simulator
# Make sure the last item on the line is the name of the
# testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work top_tb

# Source the wave do file
# This should be the file that sets up the signal window for
# the module you are testing.
do top_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End