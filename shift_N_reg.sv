module shift_N_reg #(parameter WIDTH = 1, HEIGHT = 1) (
	input logic clk, reset,
	input logic [HEIGHT-1:0] in,
	output logic [WIDTH-1:0][HEIGHT-1:0] out
	);
	
	D_FF #(HEIGHT) reg0 (.clk, .reset, .d(in), .q(out[0]));
	
	genvar i;
	generate
		for (i = 0; i < WIDTH-1; i++) begin : d_ff_block
			D_FF #(HEIGHT) regN (.clk, .reset, .d(out[i]), .q(out[i+1]));
		end
	endgenerate
endmodule

module shift_N_reg_tb ();
	logic clk, reset;
	logic [5-1:0] in;
	logic [4-1:0][5-1:0] out;
	
	shift_N_reg #(4, 5) dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; in <= 0; @(posedge clk);
		reset <= 0; in <= 5'b10011; @(posedge clk);
		@(posedge clk);
		in <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule
