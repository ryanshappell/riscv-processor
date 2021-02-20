module imm_gen (
	input logic [2:0] i_type,
	input logic [31:0] instruction,
	output logic [31:0] immediate
	);
	
	localparam I_TYPE = 3'b0;
	localparam S_TYPE = 3'b001;
	localparam B_TYPE = 3'b010;
	localparam U_TYPE = 3'b011;
	localparam J_TYPE = 3'b100;
	
	always_comb begin
	// dont need for R-type
		case (i_type)
			I_TYPE: immediate = {{20{instruction[31]}}, instruction[31:20]}; // I-type
			S_TYPE: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
			B_TYPE: immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
			U_TYPE: immediate = {instruction[31:12], 12'b0}; // U-type
			J_TYPE: immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type
			default: immediate = 32'b0;
		endcase
	end

endmodule

module imm_gen_tb ();
	logic [2:0] i_type;
	logic [31:0] instruction;
	logic [31:0] immediate;
	
	imm_gen dut (.*);
	
	initial begin
//		i_type = 0; instruction = 32'b00000000101000000000000010010011; #(100); // addi	x1, x0, 10 (I)
		i_type = 4; instruction = 32'b11111111000111101111000011101111; #(100); // jal	x1, -4
		// 1 1111111000 1 11101111 00001 1101111
		// imm = 1 11101111 1 1111111000 0
		$stop;
	end
endmodule
