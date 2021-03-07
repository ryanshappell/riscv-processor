onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /forwarding_unit_tb/EX_MEM_reg_write
add wave -noupdate /forwarding_unit_tb/MEM_WB_reg_write
add wave -noupdate /forwarding_unit_tb/rs1
add wave -noupdate /forwarding_unit_tb/rs2
add wave -noupdate /forwarding_unit_tb/EX_MEM_rd
add wave -noupdate /forwarding_unit_tb/MEM_WB_rd
add wave -noupdate -radix hexadecimal /forwarding_unit_tb/r_data1
add wave -noupdate -radix hexadecimal /forwarding_unit_tb/r_data2
add wave -noupdate -radix hexadecimal /forwarding_unit_tb/EX_MEM_out
add wave -noupdate -radix hexadecimal /forwarding_unit_tb/MEM_WB_out
add wave -noupdate -radix hexadecimal /forwarding_unit_tb/forward_A
add wave -noupdate -radix hexadecimal /forwarding_unit_tb/forward_B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {108 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 243
configure wave -valuecolwidth 69
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {735 ps}
