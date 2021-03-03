onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /register_file_tb/clk
add wave -noupdate /register_file_tb/reset
add wave -noupdate /register_file_tb/reg_write
add wave -noupdate /register_file_tb/r_addr1
add wave -noupdate /register_file_tb/r_addr2
add wave -noupdate /register_file_tb/w_addr
add wave -noupdate /register_file_tb/w_data
add wave -noupdate /register_file_tb/r_data1
add wave -noupdate /register_file_tb/r_data2
add wave -noupdate /register_file_tb/dut/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 174
configure wave -valuecolwidth 213
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
WaveRestoreZoom {0 ps} {788 ps}
