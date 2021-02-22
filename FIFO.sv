/*
Ryan Shappell
EE 371

Main FIFO module, uses ram memory in conjunction with a control module

Inputs: System clock, reset, read and write signals, input data
Outputs: Empty and full status, output data
*/
module FIFO #(parameter DEPTH = 8) (
	input logic clk, reset,
	input logic read, write,
	input logic [7:0] inputBus,
	output logic empty, full,
	output logic [7:0] outputBus
	);
	
	logic wr_en;
	logic [DEPTH-1:0] writeAddr, readAddr;
	
	logic [7:0] ram [DEPTH-1:0];
	
	always_ff @(posedge clk) begin
		if (wr_en)
			ram[writeAddr] <= inputBus;
		if (read)
			outputBus <= ram[readAddr];
	end
	
	// Memory portion of FIFO
//	ram_dual #(DEPTH, WIDTH) r (.clk, .wr_en, .din(inputBus), .readAddr, .writeAddr, .dout(outputBus));
	
	// FIFO-Control_Module			
	FIFO_Control #(DEPTH) FC (.clk, .reset, .read, .write, .wr_en, .empty, .full, .readAddr, .writeAddr);
endmodule 

module FIFO_testbench();
	parameter DEPTH = 4, WIDTH = 8;
	
	logic clk, reset;
	logic read, write;
	logic [WIDTH-1:0] inputBus;
	logic empty, full;
	logic [WIDTH/2-1:0] outputBus;
	
	FIFO #(DEPTH, WIDTH) dut (.clk, .reset, .read, .write, .inputBus, .empty, .full, .outputBus);
	
	// setup clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	// Tests reading empty and writing full as well as filling and emptying the FIFO
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0;
		read <= 0; 	write <= 1;
		for (int i = 0; i < 16; i++) begin
			inputBus <= i + 15; @(posedge clk);
		end
		read <= 1; write <= 0;
		for (int i = 0; i < 32; i++) begin
			@(posedge clk);
		end
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule 