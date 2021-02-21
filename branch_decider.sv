module branch_decider (
	input logic [2:0] branch_type,
	input logic zero, neg, c_out, over,
	output logic branch_taken
	);
	
	localparam NONE = 3'b000;
	localparam BEQ = 	3'b001;
	localparam BNE = 	3'b010;
	localparam BLT = 	3'b011;
	localparam BGE = 	3'b100;
	localparam BLTU = 3'b101;
	localparam BGEU = 3'b110;
	
	always_comb begin
		case (branch_type)
			NONE: branch_taken = 1'b0;
			BEQ: branch_taken = zero;
			BNE: branch_taken = ~zero;
			BLT: branch_taken = (neg != over);
			BGE: branch_taken = ~(neg != over);
			BLTU: branch_taken = ~c_out;
			BGEU: branch_taken = c_out;
			default: branch_taken = 1'b0;
		endcase
	end
endmodule

`ifndef LINT
module branch_decider_tb ();
	logic [1:0] branch_type;
	logic zero, neg, c_out, over;
	logic branch_taken;
	
	branch_decider dut (.*);
	
	initial begin
		branch_type = 0; zero = 0; neg = 0; #(100);
		branch_type = 0; zero = 0; neg = 1; #(100);
		branch_type = 0; zero = 1; neg = 0; #(100);
		branch_type = 1; zero = 0; neg = 0; #(100);
		branch_type = 1; zero = 0; neg = 1; #(100);
		branch_type = 1; zero = 1; neg = 0; #(100);
		branch_type = 2; zero = 0; neg = 0; #(100);
		branch_type = 2; zero = 0; neg = 1; #(100);
		branch_type = 2; zero = 1; neg = 0; #(100);
		branch_type = 3; zero = 0; neg = 0; #(100);
		branch_type = 3; zero = 0; neg = 1; #(100);
		branch_type = 3; zero = 1; neg = 0; #(100);
		$stop;
	end
endmodule
`endif
