module cpu (
	input logic clk, reset,
	output logic data_write,
	output logic [7:0] data,
	output logic [31:0] data_address
	);
	
	localparam STAGES_1 = 1;
	localparam STAGES_2 = 2;
	localparam STAGES_3 = 3;
	localparam STAGES_4 = 4;
	
	localparam STAGE_1 = 0;
	localparam STAGE_2 = 1;
	localparam STAGE_3 = 2;
	localparam STAGE_4 = 3;
	
	// Piped values
	logic [STAGE_1:0][31:0] p_forward_B, p_immediate, p_jump_addr, p_w_data, p_instruction;
	logic [STAGE_1:0][4:0] p_rs1, p_rs2;
	logic [STAGE_1:0][2:0] p_alu_op, p_branch_type;
	logic [STAGE_1:0][1:0] p_shift_type;
	logic [STAGE_1:0] p_alu_src, p_auipc, p_shift, p_slt, p_jalr, p_jump;
	logic [STAGE_1:0] p_ID_EX_reg_write, p_EX_MEM_reg_write, p_MEM_WB_reg_write, p_forward_reg_write, p_ID_EX_mem_write, p_EX_MEM_mem_write;
	
	logic [STAGE_2:0][31:0] p_i_addr, p_EX_result;
	logic [STAGE_2:0][2:0] p_xfer_size;
	logic [STAGE_2:0] p_mem_read, p_is_unsigned, p_pc_src;
	
	logic [STAGE_3:0] p_mem_to_reg;
	
	logic [STAGE_4:0][4:0] p_rd;
	
	// IF stage outputs
	logic [31:0] i_addr, instruction, jump_addr, jump_addr_src, latest_instruction;
	// Parts of instruction
	logic [4:0] rd, rs1, rs2;
	
	// ID stage outputs
	logic [31:0] r_data1, r_data2, immediate, forward_A, forward_B;
	logic [2:0] alu_op, xfer_size, branch_type;
	logic [1:0] shift_type;
	logic alu_src, auipc, shift, slt, mem_write, mem_read, mem_to_reg, pc_src, jump, jalr, is_unsigned, stall, i_valid;
	
	// EX stage outputs
	logic [31:0] EX_result, alu_A_in, alu_B_in, alu_result, slt_result, jump_result, shifted_val, less_than;
	logic zero, neg, c_out, over, branch_taken;
	
	// MEM stage outputs
	logic [31:0] r_data;
	
	// WB stage outputs
	logic [31:0] w_data;
	logic reg_write;
	
	// Pipeline stage buffers
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_forward_B (.clk, .reset, .in(forward_B), .out(p_forward_B));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_immediate (.clk, .reset, .in(immediate), .out(p_immediate));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_jump_addr (.clk, .reset, .in(jump_addr), .out(p_jump_addr));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_w_data (.clk, .reset, .in(w_data), .out(p_w_data));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_instruction (.clk, .reset, .in(latest_instruction), .out(p_instruction));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(5)) shift_rs1 (.clk, .reset, .in(rs1), .out(p_rs1));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(5)) shift_rs2 (.clk, .reset, .in(rs2), .out(p_rs2));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(3)) shift_alu_op (.clk, .reset, .in(alu_op), .out(p_alu_op));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(3)) shift_branch_type (.clk, .reset, .in(branch_type), .out(p_branch_type));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(2)) shift_shift_type (.clk, .reset, .in(shift_type), .out(p_shift_type));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_alu_src (.clk, .reset, .in(alu_src), .out(p_alu_src));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_auipc (.clk, .reset, .in(auipc), .out(p_auipc));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_shift (.clk, .reset, .in(shift), .out(p_shift));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_slt (.clk, .reset, .in(slt), .out(p_slt));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_jump (.clk, .reset, .in(p_pc_src[STAGE_1] ? 1'b0 : jump), .out(p_jump));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_jalr (.clk, .reset, .in(jalr), .out(p_jalr));
	
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_ID_EX_reg_write (.clk, .reset, .in(reg_write), .out(p_ID_EX_reg_write));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_EX_MEM_reg_write (.clk, .reset, .in(p_pc_src[STAGE_1] ? 1'b0 : p_ID_EX_reg_write[STAGE_1]), .out(p_EX_MEM_reg_write));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_MEM_WB_reg_write (.clk, .reset, .in(p_EX_MEM_reg_write[STAGE_1]), .out(p_MEM_WB_reg_write));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_forward_reg_write (.clk, .reset, .in(p_MEM_WB_reg_write[STAGE_1]), .out(p_forward_reg_write));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_ID_EX_mem_write (.clk, .reset, .in(mem_write), .out(p_ID_EX_mem_write));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_EX_MEM_mem_write (.clk, .reset, .in(p_pc_src[STAGE_1] ? 1'b0 : p_ID_EX_mem_write[STAGE_1]), .out(p_EX_MEM_mem_write));
	
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(32)) shift_i_addr (.clk, .reset, .in(stall ? p_i_addr[STAGE_1] : i_addr), .out(p_i_addr));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(32)) shift_EX_result (.clk, .reset, .in(EX_result), .out(p_EX_result));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(3)) shift_xfer_size (.clk, .reset, .in(xfer_size), .out(p_xfer_size));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(1)) shift_mem_read (.clk, .reset, .in(p_pc_src[STAGE_1] ? 1'b0 : mem_read), .out(p_mem_read));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(1)) shift_is_unsigned (.clk, .reset, .in(is_unsigned), .out(p_is_unsigned));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(1)) shift_pc_src (.clk, .reset, .in(p_pc_src[STAGE_1] ? 1'b0 : pc_src), .out(p_pc_src));
	
	
	shift_N_reg #(.WIDTH(STAGES_3), .HEIGHT(1)) shift_mem_to_reg (.clk, .reset, .in(mem_to_reg), .out(p_mem_to_reg));
	
	shift_N_reg #(.WIDTH(STAGES_4), .HEIGHT(5)) shift_rd (.clk, .reset, .in(rd), .out(p_rd));
	
	// Piece together the cpu lol
	// IF
	assign jump_addr_src = p_jalr[STAGE_1] ? forward_A : p_i_addr[STAGE_2];
	assign jump_addr = jump_addr_src + p_immediate[STAGE_1];
	PC pc (.clk, .reset, .pc_src(p_pc_src[STAGE_1]), .stall, .jump_addr(p_jump_addr[STAGE_1]), .i_valid, .i_addr);
	instruction_mem imem (.clk, .i_addr, .instruction(latest_instruction));
	
	assign instruction = ((i_addr == 0) || p_pc_src[STAGE_1] || p_pc_src[STAGE_2]) ? 32'b0 : (i_valid ? latest_instruction : p_instruction[STAGE_1]);
	
	assign rd = instruction[11:7];
	assign rs1 = instruction[19:15];
	assign rs2 = instruction[24:20];
	
	// ID
	control c (.instruction, .i_valid(~stall && ~p_pc_src[STAGE_1]), .immediate, .shift_type, .branch_type, .reg_write, .alu_op,
					.alu_src, .auipc, .shift, .slt, .mem_write, .mem_read, .xfer_size, .mem_to_reg, .jump, .jalr, .is_unsigned);
					
	register_file rf (.clk, .reset, .reg_write(p_MEM_WB_reg_write[STAGE_1]), .r_addr1(rs1),
							.r_addr2(rs2), .w_addr(p_rd[STAGE_3]),
							.w_data, .r_data1, .r_data2);
							
	hazard_detection_unit hdu (.ID_EX_mem_read(p_mem_to_reg[STAGE_1]), .ID_EX_rd(p_rd[STAGE_1]), .IF_ID_rs1(rs1), .IF_ID_rs2(rs2), .stall);
	
	// EX
	forwarding_unit fu (.EX_MEM_reg_write(p_EX_MEM_reg_write[STAGE_1]), .MEM_WB_reg_write(p_MEM_WB_reg_write[STAGE_1]), .reg_write(p_forward_reg_write[STAGE_1]),
							.rs1(p_rs1[STAGE_1]), .rs2(p_rs2[STAGE_1]), .EX_MEM_rd(p_rd[STAGE_2]), .MEM_WB_rd(p_rd[STAGE_3]), .w_addr(p_rd[STAGE_4]),
							.r_data1, .r_data2, .EX_MEM_out(p_EX_result[STAGE_1]), .MEM_WB_out(w_data), .w_data(p_w_data[STAGE_1]), .forward_A, .forward_B);
	
	assign alu_A_in = p_auipc[STAGE_1] ? p_i_addr[STAGE_2] : forward_A;
	assign alu_B_in = p_alu_src[STAGE_1] ? p_immediate[STAGE_1] : forward_B;
	alu a (.A(alu_A_in), .B(alu_B_in), .alu_op(p_alu_op[STAGE_1]), .result(alu_result), .zero, .neg, .c_out, .over);
	
	assign less_than = p_is_unsigned[STAGE_1] ? {31'b0, ~c_out} : {31'b0, (neg != over)};
	assign slt_result = p_slt[STAGE_1] ? less_than : alu_result;
	assign jump_result = p_jump[STAGE_1] ? (p_i_addr[STAGE_2]+4) : slt_result;
	shifter s (.val(alu_A_in), .shamt(alu_B_in[4:0]), .shift_type(p_shift_type[STAGE_1]), .shifted_val);
	assign EX_result = p_shift[STAGE_1] ? shifted_val : jump_result;
	
	assign pc_src = (p_jump[STAGE_1] || branch_taken);
	branch_decider bd (.branch_type(p_branch_type[STAGE_1]), .zero, .neg, .c_out, .over, .branch_taken);
	
	// MEM
	data_mem dm (.clk, .mem_write(p_EX_MEM_mem_write[STAGE_1]), .mem_read(p_mem_read[STAGE_2]), .is_unsigned(p_is_unsigned[STAGE_2]), 
						.xfer_size(p_xfer_size[STAGE_2]), .address(p_EX_result[STAGE_1] - 65536), .w_data(p_forward_B[STAGE_1]), .r_data);
	
	// WB
	assign w_data = p_mem_to_reg[STAGE_3] ? r_data : p_EX_result[STAGE_2];
	
	assign data_write = p_EX_MEM_mem_write[STAGE_1];
	assign data_address = p_EX_result[STAGE_1];
	assign data = p_forward_B[STAGE_1][7:0];
endmodule

`ifndef LINT
module cpu_tb ();
	logic clk, reset;
	logic data_write;
	logic [7:0] data;
	logic [31:0] data_address;
	
	cpu dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for (int i = 0; i < 1000; i++)
			@(posedge clk);
		$stop;
	end
endmodule
`endif
