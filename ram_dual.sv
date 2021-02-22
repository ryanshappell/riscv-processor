/*
Ryan Shappell
EE 371

32x4 dual port ram unit, parameterized depth and width

Inputs: System clock, write enable, data input, read/write address
Outputs: data output
*/
module ram_dual #(parameter DEPTH = 4, parameter WIDTH = 8)
(clk, wr_en, din, readAddr, writeAddr, dout);
	input logic clk, wr_en;
	input logic [WIDTH-1:0] din;
	input logic [DEPTH-1:0] writeAddr;
	input logic [DEPTH:0] readAddr;
	output logic [WIDTH/2-1:0] dout;

	logic [WIDTH-1:0] ram [2**DEPTH-1:0];
	
	// If writing is enabled, write to the write address
	always_ff @(posedge clk) begin
		if (wr_en)
			ram[writeAddr] <= din;
			
		// Output data at the given read address
		//dout <= ram[readAddr];
		if (readAddr[0])
			dout <= ram[readAddr[DEPTH:1]][WIDTH/2 - 1:0];
		else
			dout <= ram[readAddr[DEPTH:1]][WIDTH-1:WIDTH/2];
	end
endmodule

module ram_dual_testbench();
	parameter DEPTH = 4, WIDTH = 8;
	logic clk, wr_en;
	logic [WIDTH-1:0] din;
	logic [DEPTH-1:0] readAddr, writeAddr;
	logic [WIDTH-1:0] dout;
	
	ram_dual dut (.clk, .wr_en, .din, .readAddr, .writeAddr, .dout);
	
	// setup clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	// Write values to each address then read them
	initial begin
		wr_en <= 1; din <= 0; readAddr <= 0; writeAddr <= 0; @(posedge clk);
		for (int i = 1; i < 2**4; i++) begin
			readAddr <= i; writeAddr <= i; din <= i; @(posedge clk);
		end
		wr_en <= 0; din <= 0; @(posedge clk);
		for (int i = 1; i < 2**4; i++) begin
			readAddr <= i; writeAddr <= i; @(posedge clk);
		end
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule
