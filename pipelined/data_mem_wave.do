onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_mem_tb/clk
add wave -noupdate /data_mem_tb/mem_write
add wave -noupdate /data_mem_tb/mem_read
add wave -noupdate /data_mem_tb/xfer_size
add wave -noupdate -radix decimal /data_mem_tb/address
add wave -noupdate -radix hexadecimal -childformat {{{/data_mem_tb/w_data[31]} -radix hexadecimal} {{/data_mem_tb/w_data[30]} -radix hexadecimal} {{/data_mem_tb/w_data[29]} -radix hexadecimal} {{/data_mem_tb/w_data[28]} -radix hexadecimal} {{/data_mem_tb/w_data[27]} -radix hexadecimal} {{/data_mem_tb/w_data[26]} -radix hexadecimal} {{/data_mem_tb/w_data[25]} -radix hexadecimal} {{/data_mem_tb/w_data[24]} -radix hexadecimal} {{/data_mem_tb/w_data[23]} -radix hexadecimal} {{/data_mem_tb/w_data[22]} -radix hexadecimal} {{/data_mem_tb/w_data[21]} -radix hexadecimal} {{/data_mem_tb/w_data[20]} -radix hexadecimal} {{/data_mem_tb/w_data[19]} -radix hexadecimal} {{/data_mem_tb/w_data[18]} -radix hexadecimal} {{/data_mem_tb/w_data[17]} -radix hexadecimal} {{/data_mem_tb/w_data[16]} -radix hexadecimal} {{/data_mem_tb/w_data[15]} -radix hexadecimal} {{/data_mem_tb/w_data[14]} -radix hexadecimal} {{/data_mem_tb/w_data[13]} -radix hexadecimal} {{/data_mem_tb/w_data[12]} -radix hexadecimal} {{/data_mem_tb/w_data[11]} -radix hexadecimal} {{/data_mem_tb/w_data[10]} -radix hexadecimal} {{/data_mem_tb/w_data[9]} -radix hexadecimal} {{/data_mem_tb/w_data[8]} -radix hexadecimal} {{/data_mem_tb/w_data[7]} -radix hexadecimal} {{/data_mem_tb/w_data[6]} -radix hexadecimal} {{/data_mem_tb/w_data[5]} -radix hexadecimal} {{/data_mem_tb/w_data[4]} -radix hexadecimal} {{/data_mem_tb/w_data[3]} -radix hexadecimal} {{/data_mem_tb/w_data[2]} -radix hexadecimal} {{/data_mem_tb/w_data[1]} -radix hexadecimal} {{/data_mem_tb/w_data[0]} -radix hexadecimal}} -subitemconfig {{/data_mem_tb/w_data[31]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[30]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[29]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[28]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[27]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[26]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[25]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[24]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[23]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[22]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[21]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[20]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[19]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[18]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[17]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[16]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[15]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[14]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[13]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[12]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[11]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[10]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[9]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[8]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[7]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[6]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[5]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[4]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[3]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[2]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[1]} {-height 15 -radix hexadecimal} {/data_mem_tb/w_data[0]} {-height 15 -radix hexadecimal}} /data_mem_tb/w_data
add wave -noupdate -radix hexadecimal /data_mem_tb/r_data
add wave -noupdate -childformat {{{/data_mem_tb/dut/mem[1]} -radix hexadecimal -childformat {{{/data_mem_tb/dut/mem[1][3]} -radix binary} {{/data_mem_tb/dut/mem[1][2]} -radix binary} {{/data_mem_tb/dut/mem[1][1]} -radix binary} {{/data_mem_tb/dut/mem[1][0]} -radix binary}}} {{/data_mem_tb/dut/mem[0]} -radix hexadecimal -childformat {{{/data_mem_tb/dut/mem[0][3]} -radix binary} {{/data_mem_tb/dut/mem[0][2]} -radix binary} {{/data_mem_tb/dut/mem[0][1]} -radix binary} {{/data_mem_tb/dut/mem[0][0]} -radix binary}}}} -expand -subitemconfig {{/data_mem_tb/dut/mem[1]} {-height 15 -radix hexadecimal -childformat {{{/data_mem_tb/dut/mem[1][3]} -radix binary} {{/data_mem_tb/dut/mem[1][2]} -radix binary} {{/data_mem_tb/dut/mem[1][1]} -radix binary} {{/data_mem_tb/dut/mem[1][0]} -radix binary}}} {/data_mem_tb/dut/mem[1][3]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[1][2]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[1][1]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[1][0]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[0]} {-height 15 -radix hexadecimal -childformat {{{/data_mem_tb/dut/mem[0][3]} -radix binary} {{/data_mem_tb/dut/mem[0][2]} -radix binary} {{/data_mem_tb/dut/mem[0][1]} -radix binary} {{/data_mem_tb/dut/mem[0][0]} -radix binary}}} {/data_mem_tb/dut/mem[0][3]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[0][2]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[0][1]} {-height 15 -radix binary} {/data_mem_tb/dut/mem[0][0]} {-height 15 -radix binary}} /data_mem_tb/dut/mem
add wave -noupdate /data_mem_tb/dut/byte_en
add wave -noupdate -radix hexadecimal /data_mem_tb/dut/word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 209
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
WaveRestoreZoom {0 ps} {893 ps}
