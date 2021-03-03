onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /branch_decider_tb/branch_type
add wave -noupdate /branch_decider_tb/zero
add wave -noupdate /branch_decider_tb/neg
add wave -noupdate /branch_decider_tb/branch_taken
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {419 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1260 ps}
