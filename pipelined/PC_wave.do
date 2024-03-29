onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /PC_tb/clk
add wave -noupdate /PC_tb/reset
add wave -noupdate /PC_tb/pc_src
add wave -noupdate /PC_tb/stall
add wave -noupdate -radix decimal /PC_tb/jump_addr
add wave -noupdate /PC_tb/i_valid
add wave -noupdate -radix decimal /PC_tb/i_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {617 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 165
configure wave -valuecolwidth 203
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
WaveRestoreZoom {0 ps} {3308 ps}
