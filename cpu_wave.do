onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/reset
add wave -noupdate -radix decimal /cpu_tb/dut/pc/i_addr
add wave -noupdate -radix hexadecimal /cpu_tb/dut/imem/instruction
add wave -noupdate -childformat {{{/cpu_tb/dut/rf/regs[31]} -radix decimal} {{/cpu_tb/dut/rf/regs[30]} -radix decimal} {{/cpu_tb/dut/rf/regs[29]} -radix decimal} {{/cpu_tb/dut/rf/regs[28]} -radix decimal} {{/cpu_tb/dut/rf/regs[27]} -radix decimal} {{/cpu_tb/dut/rf/regs[26]} -radix decimal} {{/cpu_tb/dut/rf/regs[25]} -radix decimal} {{/cpu_tb/dut/rf/regs[24]} -radix decimal} {{/cpu_tb/dut/rf/regs[23]} -radix decimal} {{/cpu_tb/dut/rf/regs[22]} -radix decimal} {{/cpu_tb/dut/rf/regs[21]} -radix decimal} {{/cpu_tb/dut/rf/regs[20]} -radix decimal} {{/cpu_tb/dut/rf/regs[19]} -radix decimal} {{/cpu_tb/dut/rf/regs[18]} -radix decimal} {{/cpu_tb/dut/rf/regs[17]} -radix decimal} {{/cpu_tb/dut/rf/regs[16]} -radix decimal} {{/cpu_tb/dut/rf/regs[15]} -radix decimal} {{/cpu_tb/dut/rf/regs[14]} -radix decimal} {{/cpu_tb/dut/rf/regs[13]} -radix decimal} {{/cpu_tb/dut/rf/regs[12]} -radix decimal} {{/cpu_tb/dut/rf/regs[11]} -radix decimal} {{/cpu_tb/dut/rf/regs[10]} -radix decimal} {{/cpu_tb/dut/rf/regs[9]} -radix decimal} {{/cpu_tb/dut/rf/regs[8]} -radix decimal} {{/cpu_tb/dut/rf/regs[7]} -radix decimal} {{/cpu_tb/dut/rf/regs[6]} -radix decimal} {{/cpu_tb/dut/rf/regs[5]} -radix decimal} {{/cpu_tb/dut/rf/regs[4]} -radix decimal} {{/cpu_tb/dut/rf/regs[3]} -radix decimal} {{/cpu_tb/dut/rf/regs[2]} -radix decimal} {{/cpu_tb/dut/rf/regs[1]} -radix decimal} {{/cpu_tb/dut/rf/regs[0]} -radix decimal}} -subitemconfig {{/cpu_tb/dut/rf/regs[31]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[30]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[29]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[28]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[27]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[26]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[25]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[24]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[23]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[22]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[21]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[20]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[19]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[18]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[17]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[16]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[15]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[14]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[13]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[12]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[11]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[10]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[9]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[8]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[7]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[6]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[5]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[4]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[3]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[2]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[1]} {-height 15 -radix decimal} {/cpu_tb/dut/rf/regs[0]} {-height 15 -radix decimal}} /cpu_tb/dut/rf/regs
add wave -noupdate -radix decimal {/cpu_tb/dut/rf/regs[2]}
add wave -noupdate -radix decimal {/cpu_tb/dut/rf/regs[1]}
add wave -noupdate -radix decimal {/cpu_tb/dut/rf/regs[0]}
add wave -noupdate -expand /cpu_tb/dut/p_r_data2
add wave -noupdate /cpu_tb/dut/r_data2
add wave -noupdate /cpu_tb/dut/p_immediate
add wave -noupdate -radix decimal /cpu_tb/dut/alu_A_in
add wave -noupdate /cpu_tb/dut/p_auipc
add wave -noupdate -radix decimal /cpu_tb/dut/alu_B_in
add wave -noupdate -expand /cpu_tb/dut/p_alu_src
add wave -noupdate /cpu_tb/dut/p_alu_op
add wave -noupdate /cpu_tb/dut/p_slt
add wave -noupdate -expand /cpu_tb/dut/p_EX_result
add wave -noupdate -expand /cpu_tb/dut/p_reg_write
add wave -noupdate /cpu_tb/dut/can_write
add wave -noupdate -childformat {{{/cpu_tb/dut/dm/mem[1]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0]} -radix hexadecimal -childformat {{{/cpu_tb/dut/dm/mem[0][3]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0][2]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0][1]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0][0]} -radix hexadecimal}}}} -subitemconfig {{/cpu_tb/dut/dm/mem[1]} {-height 15 -radix hexadecimal} {/cpu_tb/dut/dm/mem[0]} {-height 15 -radix hexadecimal -childformat {{{/cpu_tb/dut/dm/mem[0][3]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0][2]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0][1]} -radix hexadecimal} {{/cpu_tb/dut/dm/mem[0][0]} -radix hexadecimal}}} {/cpu_tb/dut/dm/mem[0][3]} {-height 15 -radix hexadecimal} {/cpu_tb/dut/dm/mem[0][2]} {-height 15 -radix hexadecimal} {/cpu_tb/dut/dm/mem[0][1]} {-height 15 -radix hexadecimal} {/cpu_tb/dut/dm/mem[0][0]} {-height 15 -radix hexadecimal}} /cpu_tb/dut/dm/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1037 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
configure wave -valuecolwidth 220
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
WaveRestoreZoom {816 ps} {2040 ps}
