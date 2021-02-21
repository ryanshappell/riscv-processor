module cpu (
	input logic clk, reset
	);
	
	localparam STAGES_1 = 1;
	localparam STAGES_2 = 2;
	localparam STAGES_3 = 3;
	
	localparam STAGE_1 = 0;
	localparam STAGE_2 = 1;
	localparam STAGE_3 = 2;
	
	// Piped values
	logic [STAGE_1:0][31:0] p_r_data2, p_immediate, p_jump_addr;
	logic [STAGE_1:0][2:0] p_alu_op;
	logic [STAGE_1:0][1:0] p_shift_type;
	logic [STAGE_1:0] p_alu_src, p_auipc, p_shift, p_slt, p_jalr, p_jump, p_pc_src;
	
	logic [STAGE_2:0][31:0] p_i_addr, p_EX_result;
	logic [STAGE_2:0][2:0] p_xfer_size, p_branch_type;
	logic [STAGE_2:0] p_mem_write, p_mem_read, p_is_unsigned;
	
	logic [STAGE_3:0] p_reg_write, p_mem_to_reg;
	
	// IF stage outputs
	logic [31:0] i_addr, instruction, jump_addr;
	
	// ID stage outputs
	logic [31:0] r_data1, r_data2, immediate;
	logic [2:0] alu_op, xfer_size, branch_type;
	logic [1:0] shift_type;
	logic alu_src, auipc, shift, slt, mem_write, mem_read, mem_to_reg, pc_src, jump, jalr, is_unsigned;
	
	// EX stage outputs
	logic [31:0] EX_result;
	
	// MEM stage outputs
	logic [31:0] r_data;
	
	// WB stage outputs
	logic [31:0] w_data;
	logic reg_write;
	
	// Pipeline stage buffers
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_r_data2 (.clk, .reset, .in(r_data2), .out(p_r_data2));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_immediate (.clk, .reset, .in(immediate), .out(p_immediate));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_jump_addr (.clk, .reset, .in(jump_addr), .out(p_jump_addr));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(3)) shift_alu_op (.clk, .reset, .in(alu_op), .out(p_alu_op));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(2)) shift_shift_type (.clk, .reset, .in(shift_type), .out(p_shift_type));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_alu_src (.clk, .reset, .in(alu_src), .out(p_alu_src));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_auipc (.clk, .reset, .in(auipc), .out(p_auipc));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_shift (.clk, .reset, .in(shift), .out(p_shift));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_slt (.clk, .reset, .in(slt), .out(p_slt));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_jump (.clk, .reset, .in(jump), .out(p_jump));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_jalr (.clk, .reset, .in(jalr), .out(p_jalr));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_pc_src (.clk, .reset, .in(pc_src), .out(p_pc_src));
	
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(32)) shift_i_addr (.clk, .reset, .in(i_addr), .out(p_i_addr));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(32)) shift_EX_result (.clk, .reset, .in(EX_result), .out(p_EX_result));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(3)) shift_xfer_size (.clk, .reset, .in(xfer_size), .out(p_xfer_size));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(3)) shift_branch_type (.clk, .reset, .in(branch_type), .out(p_branch_type));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(1)) shift_mem_write (.clk, .reset, .in(mem_write), .out(p_mem_write));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(1)) shift_mem_read (.clk, .reset, .in(mem_read), .out(p_mem_read));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(1)) shift_is_unsigned (.clk, .reset, .in(is_unsigned), .out(p_is_unsigned));
	
	shift_N_reg #(.WIDTH(STAGES_3), .HEIGHT(1)) shift_reg_write (.clk, .reset, .in(reg_write), .out(p_reg_write));
	shift_N_reg #(.WIDTH(STAGES_3), .HEIGHT(1)) shift_mem_to_reg (.clk, .reset, .in(mem_to_reg), .out(p_mem_to_reg));
	
	// Piece together the cpu lol
	// IF
	logic can_write;
	logic [31:0] jump_addr_src;
	assign jump_addr_src = p_jalr[STAGE_1] ? r_data1 : p_i_addr[STAGE_2];
	assign jump_addr = jump_addr_src + p_immediate[STAGE_1];
	PC pc (.clk, .reset, .pc_src(p_pc_src[STAGE_1]), .jump_addr(p_jump_addr[STAGE_1]), .i_addr, .can_write);
	instruction_mem imem (.clk, .i_addr, .instruction);
	
	// ID
	control c (.instruction, .immediate, .shift_type, .branch_type, .reg_write(reg_write), .alu_op, .alu_src, .auipc, .shift, .slt, .mem_write, .mem_read, .xfer_size, .mem_to_reg, .jump, .jalr, .is_unsigned);
	register_file rf (.clk, .reset, .reg_write((p_reg_write[STAGE_3] && can_write)), .r_addr1(instruction[19:15]),
							.r_addr2(instruction[24:20]), .w_addr(instruction[11:7]),
							.w_data, .r_data1, .r_data2);
	
	// EX
	logic [31:0] alu_A_in, alu_B_in, alu_result, slt_result, jump_result, shifted_val;
	logic zero, neg, c_out, over;
	
	logic [31:0] less_than;
	
	assign alu_A_in = p_auipc[STAGE_1] ? p_i_addr[STAGE_2] : r_data1;
	assign alu_B_in = p_alu_src[STAGE_1] ? p_immediate[STAGE_1] : r_data2;
	alu a (.A(alu_A_in), .B(alu_B_in), .alu_op(p_alu_op[STAGE_1]), .result(alu_result), .zero, .neg, .c_out, .over);
	
	assign less_than = p_is_unsigned[STAGE_1] ? {31'b0, ~c_out} : {31'b0, (neg != over)};
	assign slt_result = p_slt[STAGE_1] ? less_than : alu_result;

	//	assign slt_result = p_slt[STAGE_1] ? {31'b0, neg} : alu_result; // TODO: handle unsigned
	assign jump_result = p_jump[STAGE_1] ? (p_i_addr[STAGE_2]+4) : slt_result;
	shifter s (.val(r_data1), .shamt(alu_B_in[4:0]), .shift_type(p_shift_type[STAGE_1]), .shifted_val);
	assign EX_result = p_shift[STAGE_1] ? shifted_val : jump_result;
	
	logic branch_taken;
	assign pc_src = (p_jump[STAGE_1] || branch_taken);
	branch_decider bd (.branch_type(p_branch_type[STAGE_2]), .zero, .neg, .c_out, .over, .branch_taken);
	
	// MEM
	data_mem dm (.clk, .mem_write(p_mem_write[STAGE_2]), .mem_read(p_mem_read[STAGE_2]), .is_unsigned(p_is_unsigned[STAGE_2]), .xfer_size(p_xfer_size[STAGE_2]), .address(p_EX_result[STAGE_1]), .w_data(p_r_data2[STAGE_1]), .r_data);
	
	// WB
	assign w_data = p_mem_to_reg[STAGE_3] ? r_data : p_EX_result[STAGE_2];
endmodule

`ifndef LINT
module cpu_tb ();
	logic clk, reset;
	
	cpu dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for (int i = 0; i < 100; i++)
			@(posedge clk);
		$stop;
	end
endmodule
`endif
