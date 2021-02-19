onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /shifter_tb/val
add wave -noupdate /shifter_tb/shamt
add wave -noupdate /shifter_tb/shift_type
add wave -noupdate /shifter_tb/shifted_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {575 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 159
configure wave -valuecolwidth 208
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
WaveRestoreZoom {0 ps} {945 ps}
