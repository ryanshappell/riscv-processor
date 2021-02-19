module instruction_mem (
	input logic clk,
	input logic [31:0] i_addr,
	output logic [31:0] instruction
	);
	
	logic [31:0] mem [255:0]; // TODO: determine how many instructions are needed
	
	initial begin
		$readmemh("code.hex", mem);
	end
	
	always_ff @(posedge clk)
		instruction <= mem[i_addr/4];
//	always_comb begin
//		instruction = mem[i_addr/4];
//	end
endmodule

module instruction_mem_tb ();
	logic clk;
	logic [31:0] i_addr;
	logic [31:0] instruction;
	
	instruction_mem dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		i_addr <= 0; @(posedge clk);
		i_addr <= 1; @(posedge clk);
		i_addr <= 4; @(posedge clk);
		i_addr <= 5; @(posedge clk);
		i_addr <= 8; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
//		i_addr = 0; #(100);
//		i_addr = 1; #(100);
//		i_addr = 4; #(100);
//		i_addr = 5; #(100);
//		i_addr = 8; #(100);
		$stop;
	end
endmodule
