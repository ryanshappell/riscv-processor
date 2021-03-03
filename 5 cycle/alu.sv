module alu (
	input logic [31:0] A, B,
	input logic [2:0] alu_op,
	output logic [31:0] result,
	output logic zero, neg, c_out, over
	);
	
	logic [31:0] B_sub;
	logic [32:0] r;
	
	assign B_sub = (alu_op == 1) ? ~B : B;
	
	always_comb begin
		case (alu_op)
			0: r = A + B;				// add
			1: r = A + B_sub + 1;	// subtract
			2: r = {1'b0, A ^ B};	// xor
			3: r = {1'b0, A | B};	// or
			4: r = {1'b0, A & B};	// and
			5: r = {1'b0, B};			// pass B
			default: r = A + B;		// default add
		endcase
		
		result = r[31:0];
		zero = (result == 32'b0);
		neg = result[31];
		c_out = r[32];
		over = (A[31] == B_sub[31] && result[31] != B_sub[31]);
	end
endmodule

`ifndef LINT
module alu_tb ();
	logic [31:0] A, B;
	logic [2:0] alu_op;
	logic [31:0] result;
	logic zero, neg, c_out, over;

	alu dut (.*);
	
	initial begin
//		A = 0; B = 0; #(100);
//		A = 10; B = 7; alu_op = 0; #(100);
//		alu_op = 1; #(100);
//		alu_op = 2; #(100);
//		alu_op = 3; #(100);
//		alu_op = 4; #(100);
//		alu_op = 5; #(100);
//		A = 7; B = 10; alu_op = 0; #(100);
//		alu_op = 1; #(100);
//		alu_op = 2; #(100);
//		alu_op = 3; #(100);
//		alu_op = 4; #(100);
//		alu_op = 5; #(100);
		A = -1; B = 1; alu_op = 1; #(100);
		A = 0; B = 1; alu_op = 1; #(100);
		A = 1; B = 1; alu_op = 1; #(100);
		$stop;
	end
endmodule
`endif
