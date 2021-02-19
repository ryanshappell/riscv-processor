module imm_gen (
	input logic [2:0] i_type,
	input logic [31:0] instruction,
	output logic [31:0] immediate
	);
	
	always_comb begin
	// dont need for R-type
		case (i_type)
			0: immediate = {{20{instruction[31]}}, instruction[31:20]}; // I-type
			1: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
			2: immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
			3: immediate = {instruction[31:12], 12'b0}; // U-type
			4: immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type
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
		i_type = 0; instruction = 32'b00000000101000000000000010010011; #(100); // addi	x1, x0, 10 (I)
		$stop;
	end
endmodule
