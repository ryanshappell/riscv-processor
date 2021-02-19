module alu (
	input logic [31:0] A, B,
	input logic [2:0] alu_op,
	output logic [31:0] result,
	output logic zero, neg
	);
	
	always_comb begin
		case (alu_op)
			0: result = A + B;			// add
			1: result = A - B;			// subtract
			2: result = A ^ B;			// xor
			3: result = A | B;			// or
			4: result = A & B;			// and
			5: result = B;					// pass B
			default: result = A + B;	// default add
		endcase
		
		zero = (result == 0);
		neg = (result[31] == 1'b1);
	end
endmodule

module alu_tb ();
	logic [31:0] A, B;
	logic [2:0] alu_op;
	logic [31:0] result;
	logic zero, neg;

	alu dut (.*);
	
	initial begin
		A = 0; B = 0; #(100);
		A = 10; B = 7; alu_op = 0; #(100);
		alu_op = 1; #(100);
		alu_op = 2; #(100);
		alu_op = 3; #(100);
		alu_op = 4; #(100);
		alu_op = 5; #(100);
		A = 7; B = 10; alu_op = 0; #(100);
		alu_op = 1; #(100);
		alu_op = 2; #(100);
		alu_op = 3; #(100);
		alu_op = 4; #(100);
		alu_op = 5; #(100);
		$stop;
	end
endmodule
