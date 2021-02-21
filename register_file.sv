module register_file (
	input logic clk, reset, reg_write,
	input logic [4:0] r_addr1, r_addr2, w_addr,
	input logic [31:0] w_data,
	output logic [31:0] r_data1, r_data2
	);
	
	// Registers
	logic [31:0] regs [31:0];
	
//	logic [31:0] r1, r2;
	
	// Write to register if write enabled (excluding x0)
	always_ff @(posedge clk) begin
//		if (reg_write)
//			regs[w_addr] <= w_data;
//		r1 <= regs[r_addr1];
//		r2 <= regs[r_addr2];
	
		if (reset)
			regs[0] <= 0;
		else begin
			if (reg_write) begin
				if (w_addr != 0)
					regs[w_addr] <= w_data;
			end
			r_data1 <= regs[r_addr1];
			r_data2 <= regs[r_addr2];
		end
	end
//	assign r_data1 = r1;
//	assign r_data2 = r2;
endmodule

`ifndef LINT
module register_file_tb ();
	logic clk, reset, reg_write;
	logic [4:0] r_addr1, r_addr2, w_addr;
	logic [31:0] w_data;
	logic [31:0] r_data1, r_data2;
	
	register_file dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; reg_write <= 0; w_addr <= 0; w_data <= 0; r_addr1 <= 0; r_addr2 <= 0; @(posedge clk);
		reset <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		
//		reg_write <= 0; w_addr <= 0; w_data <= 0; r_addr1 <= 0; r_addr2 <= 0; @(posedge clk);
//		reg_write <= 1; w_data <= 1; @(posedge clk);
//		for (int i = 0; i < 32; i++) begin
//			w_addr <= i; w_data <= w_data << 1; @(posedge clk);
//		end
//		reg_write <= 1; w_data <= 1; @(posedge clk);
//		for (int i = 0; i < 32; i++) begin
//			w_addr <= i; w_data <= w_data << 1; @(posedge clk);
//		end
//		reg_write <= 0; @(posedge clk);
//		for (int i = 0; i < 31; i++) begin
//			r_addr1 <= i; r_addr2 <= i+1; @(posedge clk);
//		end
		$stop;
	end
endmodule
`endif
