onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /alu_tb/A
add wave -noupdate -radix binary /alu_tb/B
add wave -noupdate -radix unsigned /alu_tb/alu_op
add wave -noupdate -radix binary /alu_tb/result
add wave -noupdate /alu_tb/zero
add wave -noupdate /alu_tb/neg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {706 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 121
configure wave -valuecolwidth 200
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
WaveRestoreZoom {0 ps} {1365 ps}
