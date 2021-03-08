module hazard_detection_unit (
	input logic ID_EX_mem_read,
	input logic [4:0] ID_EX_rd, IF_ID_rs1, IF_ID_rs2,
	output logic stall
	);
	
	always_comb begin
		if (ID_EX_mem_read && ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2)))
			stall = 1'b1;
		else
			stall = 0;
	end
endmodule
