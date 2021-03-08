module PC (
	input logic clk, reset, pc_src, stall,
	input logic [31:0] jump_addr,
	output logic i_valid,
	output logic [31:0] i_addr
	);
	
	// Current instruction address
	logic [31:0] curr_addr;
	
	always @(posedge clk) begin
		if (reset) begin
			i_valid <= 1;
			curr_addr <= 0;
		end else if (stall) begin
			i_valid <= 0;
			curr_addr <= curr_addr;
		end else begin
			i_valid <= 1;
			// Increment PC
			if (pc_src)
				curr_addr <= jump_addr;
			else
				curr_addr <= curr_addr + 4;
		end
	end
	
	assign i_addr = curr_addr;
endmodule

`ifndef LINT
module PC_tb ();
	logic clk, reset, pc_src, stall;
	logic [31:0] jump_addr;
	logic i_valid;
	logic [31:0] i_addr;
	
	PC dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		// 12 clock cycles
		reset <= 1; pc_src <= 0; stall <= 0; jump_addr <= 0; @(posedge clk);
		reset <= 0; @(posedge clk);
		for (int i = 0; i < 9; i++) begin
			@(posedge clk);
		end
		pc_src <= 1; @(posedge clk);
		for (int i = 0; i < 6; i++) begin
			@(posedge clk);
		end
		pc_src <= 0; @(posedge clk);
		for (int i = 0; i < 9; i++) begin
			@(posedge clk);
		end
		stall <= 1; @(posedge clk);
		stall <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule
`endif
