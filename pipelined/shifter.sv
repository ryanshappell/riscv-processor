module shifter (
	input logic [31:0] val,
	input logic [4:0] shamt,
	input logic [1:0] shift_type,
	output logic [31:0] shifted_val
	);
	
	always_comb begin
		case (shift_type)
			0: shifted_val = val << shamt;				// left shift
			1: shifted_val = val >> shamt;				// right shift
			2: shifted_val = $signed(val) >>> shamt;	// right arithmetic shift
			default: shifted_val = val;					// default pass through
		endcase
	end
endmodule

`ifndef LINT
module shifter_tb ();
	logic [31:0] val;
	logic [4:0] shamt;
	logic [1:0] shift_type;
	logic [31:0] shifted_val;
	
	shifter dut (.*);
	
	initial begin
		val = 0; shamt = 0; shift_type = 0; #(100);
		val = 21; shamt = 0; shift_type = 3; #(100);
		shamt = 2; shift_type = 0; #(100);
		shamt = 2; shift_type = 1; #(100);
		shamt = 2; shift_type = 2; #(100);
		val = -21; shamt = 0; shift_type = 3; #(100);
		shamt = 2; shift_type = 0; #(100);
		shamt = 2; shift_type = 1; #(100);
		shamt = 2; shift_type = 2; #(100);
		val = 10; shamt = 1; shift_type = 1; #(100)
		$stop;
	end
endmodule
`endif
