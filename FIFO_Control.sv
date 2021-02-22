/*
Ryan Shappell
EE 371

FIFO Control module to keep track if the FIFO is empty or full
adjusts the read and write addresses

Inputs: System clock, reset, read/write signal
Outputs: Write enable, empty/full flags, read and write addresses
*/
module FIFO_Control #(parameter DEPTH = 4)
(
input logic clk, reset,
input logic read, write,
output logic wr_en,
output logic empty, full,
output logic [DEPTH-1:0] writeAddr, readAddr
);

	enum{s_empty, s_full, s_neither} ps, ns;
	
	// Manage state transistions
	always_comb begin
		case (ps)
			s_empty: 	if (write) ns = s_neither;
							else ns = s_empty;
							
			s_neither:	if (write & ((writeAddr + 1'b1) == readAddr)) ns = s_full;
							else if (read & ((readAddr + 1'b1) == writeAddr)) ns = s_empty;
							else ns = s_neither;
							
			s_full: 		if (read) ns = s_neither;
							else ns = s_full;
		endcase
	end
	
	// Empty and full flags based on current state
	assign empty = (ps == s_empty);
	assign full = (ps == s_full);
	
	// Write enable
	assign wr_en = (~full & write);
	
	// Based on the write/read signal and the state of the FSM the read or write address are incremented
	always_ff @(posedge clk) begin
		if (reset) begin
			readAddr <= 0;
			writeAddr <= 0;
			ps <= s_empty;
		end else begin
			if (write & ~full)
				writeAddr <= writeAddr + 1'b1;
			if (read & ~empty)
				readAddr <= readAddr + 1'b1;
			ps <= ns;
		end
	end
endmodule

module FIFO_Control_testbench();
	logic clk, reset, read, write, wr_en, empty, full;
	logic [2-1:0] writeAddr;
	logic [2:0] readAddr;
	
	FIFO_Control #(2) dut (.clk, .reset, .read, .write, .wr_en, .empty, .full, .readAddr, .writeAddr);
	
	// Setup clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	// Tests a walk through where the FIFO eventually is filled and then emptied
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0;
		read <= 0; 	write <= 0; @(posedge clk);
						write <= 1; @(posedge clk); // write once
		read <= 1;	write <= 0;	@(posedge clk); // read twice --> empty
										@(posedge clk);
		read <= 0; 	write <= 1;	
		for (int i = 0; i < 4; i++) // write 4 times --> full
			@(posedge clk);
			
		reset <= 1; @(posedge clk);
		reset <= 0;
		read <= 0; 	write <= 0; @(posedge clk);
		read <= 0; 	write <= 1;	
		for (int i = 0; i < 3; i++) // write 3 times
			@(posedge clk);
		read <= 1; write <= 0; @(posedge clk);
		read <= 0; write <= 1; @(posedge clk); // full second case
		@(posedge clk);
		$stop;
	end
endmodule
