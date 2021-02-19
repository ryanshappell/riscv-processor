module D_FF #(parameter HEIGHT = 1) (
	input logic clk, reset,
	input logic [HEIGHT-1:0] d,
	output logic [HEIGHT-1:0] q
	);
	
	always_ff @(posedge clk) begin
		if (reset)
			q <= 0;
		else
			q <= d;
	end
endmodule

module D_FF_tb ();
	logic clk, reset;
	logic [5-1:0] d;
	logic [5-1:0] q;
	
	D_FF #(5) dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; d <= 0; @(posedge clk);
		reset <= 0; d <= 5'b10011; @(posedge clk);
		d<= 0; @(posedge clk);
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
