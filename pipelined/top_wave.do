onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/RESET
add wave -noupdate /top_tb/KEY
add wave -noupdate /top_tb/LEDR
add wave -noupdate /top_tb/DIG
add wave -noupdate /top_tb/UART_TXD
add wave -noupdate /top_tb/dut/data_write
add wave -noupdate -radix decimal /top_tb/dut/data_address
add wave -noupdate -radix decimal /top_tb/dut/data
add wave -noupdate -radix decimal /top_tb/dut/utx/tx_data
add wave -noupdate /top_tb/dut/tx_ready
add wave -noupdate -radix decimal /top_tb/dut/utx/tx_data_ready
add wave -noupdate -radix decimal /top_tb/dut/fifo/outputBus
add wave -noupdate -radix decimal /top_tb/dut/fifo_out
add wave -noupdate -childformat {{{/top_tb/dut/fifo/ram[7]} -radix decimal} {{/top_tb/dut/fifo/ram[6]} -radix decimal} {{/top_tb/dut/fifo/ram[5]} -radix decimal} {{/top_tb/dut/fifo/ram[4]} -radix decimal} {{/top_tb/dut/fifo/ram[3]} -radix decimal} {{/top_tb/dut/fifo/ram[2]} -radix decimal} {{/top_tb/dut/fifo/ram[1]} -radix decimal} {{/top_tb/dut/fifo/ram[0]} -radix decimal}} -expand -subitemconfig {{/top_tb/dut/fifo/ram[7]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[6]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[5]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[4]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[3]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[2]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[1]} {-height 15 -radix decimal} {/top_tb/dut/fifo/ram[0]} {-height 15 -radix decimal}} /top_tb/dut/fifo/ram
add wave -noupdate /top_tb/dut/utx/data_shift_buffer_remaining
add wave -noupdate -radix decimal /top_tb/dut/fifo/read
add wave -noupdate -radix decimal /top_tb/dut/fifo/write
add wave -noupdate /top_tb/dut/fifo/empty
add wave -noupdate -radix decimal /top_tb/dut/fifo/writeAddr
add wave -noupdate -radix decimal /top_tb/dut/fifo/readAddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1569 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 68
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
WaveRestoreZoom {0 ps} {11968 ps}
