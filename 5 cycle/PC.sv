module PC (
	input logic clk, reset, pc_src,
	input logic [31:0] jump_addr,
	output logic [31:0] i_addr,
	output logic can_write
	);
	
	// Current instruction address
	logic [31:0] curr_addr;
	
	// Counter for 5 cycles
	logic [2:0] count;
	
	assign can_write = (count == 3'b100);
	
	always @(posedge clk) begin
		if (reset) begin
			count <= 0;
			curr_addr <= 0;
		end else begin
			if (count == 3'b100) begin
				// Increment PC
				if (pc_src)
					curr_addr <= jump_addr;
				else
					curr_addr <= curr_addr + 4;
				count <= 0;
			end else
				count <= count + 1'b1;
		end
	end
	
	assign i_addr = curr_addr;
endmodule

`ifndef LINT
module PC_tb ();
	logic clk, reset, pc_src;
	logic [31:0] jump_addr;
	logic [31:0] i_addr;
	logic can_write;
	
	PC dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		// 12 clock cycles
		reset <= 1; pc_src <= 0; jump_addr <= 0; @(posedge clk);
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
		$stop;
	end
endmodule
`endif
