module forwarding_unit (
	input logic EX_MEM_reg_write, MEM_WB_reg_write, reg_write,
	input logic [4:0] rs1, rs2, EX_MEM_rd, MEM_WB_rd, w_addr,
	input logic [31:0] r_data1, r_data2, EX_MEM_out, MEM_WB_out, w_data,
	output logic [31:0] forward_A, forward_B
	);
	
	always_comb begin
		// FORWARD A
		if (rs1 == 5'b0)
			forward_A = r_data1;
		else begin
			if (rs1 == EX_MEM_rd && EX_MEM_reg_write)
				forward_A = EX_MEM_out;
			else if (rs1 == MEM_WB_rd && MEM_WB_reg_write)
				forward_A = MEM_WB_out;
			else if (rs1 == w_addr && reg_write)
				forward_A = w_data;
			else
				forward_A = r_data1;
		end
		
		// FORWARD B
		if (rs2 == 5'b0)
			forward_B = r_data2;
		else begin
			if (rs2 == EX_MEM_rd && EX_MEM_reg_write)
				forward_B = EX_MEM_out;
			else if (rs2 == MEM_WB_rd && MEM_WB_reg_write)
				forward_B = MEM_WB_out;
			else if (rs2 == w_addr && reg_write)
				forward_B = w_data;
			else
				forward_B = r_data2;
		end
	end
endmodule

`ifndef LINT
module forwarding_unit_tb ();
	logic EX_MEM_reg_write, MEM_WB_reg_write, reg_write;
	logic [4:0] rs1, rs2, EX_MEM_rd, MEM_WB_rd, w_addr;
	logic [31:0] r_data1, r_data2, EX_MEM_out, MEM_WB_out, w_data;
	logic [31:0] forward_A, forward_B;
	
	forwarding_unit dut (.*);
	
	initial begin
		EX_MEM_reg_write = 0; MEM_WB_reg_write = 0; rs1 = 0; rs2 = 0; EX_MEM_rd = 0; MEM_WB_rd = 0; r_data1 = 250; r_data2 = 110; EX_MEM_out = 124; MEM_WB_out = 18; #(100);
		rs1 = 2; #(100);
		EX_MEM_rd = 2; MEM_WB_rd = 2; #(100);
		EX_MEM_reg_write = 1; #(100);
		MEM_WB_reg_write = 1; #(100);
		EX_MEM_reg_write = 0; #(100);
		rs2 = 3; MEM_WB_rd = 3; #(100);
		$stop;
	end
endmodule
`endif
