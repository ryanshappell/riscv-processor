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
	logic [STAGE_1:0][31:0] p_instruction, p_r_data2, p_immediate;
	logic [STAGE_1:0][2:0] p_alu_op;
	logic [STAGE_1:0][1:0] p_shift_type;
	logic [STAGE_1:0] p_alu_src, p_auipc, p_shift, p_slt;
	
	logic [STAGE_2:0][31:0] p_i_addr, p_EX_result;
	
	logic [STAGE_3:0] p_reg_write;
	
	// IF stage outputs
	logic [31:0] i_addr, instruction;
	
	// ID stage outputs
	logic [31:0] r_data1, r_data2, immediate;
	logic [2:0] alu_op;
	logic [1:0] shift_type;
	logic alu_src, auipc, shift, slt;
	
	// EX stage outputs
	logic [31:0] EX_result;
	
	// MEM stage outputs
	
	// WB stage outputs
	logic [31:0] w_data;
	logic reg_write;
	
	// Pipeline stage buffers
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_instruction (.clk, .reset, .in(instruction), .out(p_instruction));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_r_data2 (.clk, .reset, .in(r_data2), .out(p_r_data2));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(32)) shift_immediate (.clk, .reset, .in(immediate), .out(p_immediate));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(3)) shift_alu_op (.clk, .reset, .in(alu_op), .out(p_alu_op));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(2)) shift_shift_type (.clk, .reset, .in(shift_type), .out(p_shift_type));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_alu_src (.clk, .reset, .in(alu_src), .out(p_alu_src));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_auipc (.clk, .reset, .in(auipc), .out(p_auipc));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_shift (.clk, .reset, .in(shift), .out(p_shift));
	shift_N_reg #(.WIDTH(STAGES_1), .HEIGHT(1)) shift_slt (.clk, .reset, .in(slt), .out(p_slt));
	
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(32)) shift_i_addr (.clk, .reset, .in(i_addr), .out(p_i_addr));
	shift_N_reg #(.WIDTH(STAGES_2), .HEIGHT(32)) shift_EX_result (.clk, .reset, .in(EX_result), .out(p_EX_result));
	
	shift_N_reg #(.WIDTH(STAGES_3), .HEIGHT(1)) shift_reg_write (.clk, .reset, .in(reg_write), .out(p_reg_write));
	
	// Piece together the cpu lol
	// IF
	logic can_write;
	PC pc (.clk, .reset, .branch_taken(1'b0), .i_addr, .can_write);
	instruction_mem imem (.clk, .i_addr, .instruction);
	
	// ID
	control c (.instruction(p_instruction[STAGE_1]), .immediate, .shift_type, .reg_write(reg_write), .alu_op, .alu_src, .auipc, .shift, .slt);
	register_file rf (.clk, .reset, .reg_write((p_reg_write[STAGE_3] && can_write)), .r_addr1(p_instruction[STAGE_1][19:15]),
							.r_addr2(p_instruction[STAGE_1][24:20]), .w_addr(p_instruction[STAGE_1][11:7]),
							.w_data, .r_data1, .r_data2); // TODO: w_data
	
	// EX
	logic [31:0] alu_A_in, alu_B_in, alu_result, slt_result, shifted_val;
	logic neg;
	
	assign alu_A_in = p_auipc[STAGE_1] ? p_i_addr[STAGE_2] : r_data1;
	assign alu_B_in = p_alu_src[STAGE_1] ? p_immediate[STAGE_1] : r_data2;
	alu a (.A(alu_A_in), .B(alu_B_in), .alu_op(p_alu_op[STAGE_1]), .result(alu_result), .zero(), .neg);
	assign slt_result = p_slt[STAGE_1] ? {31'b0, neg} : alu_result;
	
	shifter s (.val(r_data1), .shamt(alu_B_in[4:0]), .shift_type(p_shift_type[STAGE_1]), .shifted_val);
	assign EX_result = p_shift[STAGE_1] ? shifted_val : slt_result;
	
	// MEM
	
	// WB
	assign w_data = p_EX_result[STAGE_2];
endmodule

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
