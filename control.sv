module control (
	input logic [31:0] instruction,
	output logic [31:0] immediate,
	output logic [2:0] alu_op, xfer_size, branch_type,
	output logic [1:0] shift_type,
	output logic reg_write, alu_src, auipc, shift, slt, mem_write, mem_read, mem_to_reg, jump, jalr, is_unsigned
//	output logic cf_reg_write, cf_mem_to_reg, cf_alu_op, cf_alu_src, cf_slt, cf_shift, cf_shift_type
	);
	
	// Sections of instruction
	logic [6:0] opcode, funct7;
	logic [2:0] funct3;
	logic [4:0] rd, rs1, rs2;
	
	assign opcode 	= instruction[6:0];
	assign funct7 	= instruction[31:25];
	assign funct3 	= instruction[14:12];
	assign rd 		= instruction[11:7];
	assign rs1 		= instruction[19:15];
	assign rs2 		= instruction[24:20];
	
	// Basic opcode types
	logic load, store, branch, reg_imm, reg_reg;
	
	assign load 	= (opcode == 7'b0000011);
	assign store 	= (opcode == 7'b0100011);
	assign branch	= (opcode == 7'b1100011);
	assign reg_imm = (opcode == 7'b0010011);
	assign reg_reg = (opcode == 7'b0110011);
	
	// Decoded instruction indicators
	logic i_lui, i_auipc, i_jal, i_jalr;
	logic i_beq, i_bne, i_blt, i_bge, i_bltu, i_bgeu;
	logic i_lb, i_lh, i_lw, i_lbu, i_lhu;
	logic i_sb, i_sh, i_sw;
	logic i_addi, i_slti, i_sltiu, i_xori, i_ori, i_andi, i_slli, i_srli, i_srai;
	logic i_add, i_sub, i_sll, i_slt, i_sltu, i_xor, i_srl, i_sra, i_or, i_and;
	
	// Special opcodes?
	assign i_lui 	= (opcode == 7'b0110111);
	assign i_auipc = (opcode == 7'b0010111);
	assign i_jal 	= (opcode == 7'b1101111);
	assign i_jalr	= (opcode == 7'b1100111);
	
	// Branch instructions
	assign i_beq 	= branch && (funct3 == 3'b000);
	assign i_bne 	= branch && (funct3 == 3'b001);
	assign i_blt 	= branch && (funct3 == 3'b100);
	assign i_bge 	= branch && (funct3 == 3'b101);
	assign i_bltu 	= branch && (funct3 == 3'b110);
	assign i_bgeu	= branch && (funct3 == 3'b111);
	
	// Load instructions
	assign i_lb 	= load && (funct3 == 3'b000);
	assign i_lh 	= load && (funct3 == 3'b001);
	assign i_lw 	= load && (funct3 == 3'b010);
	assign i_lbu 	= load && (funct3 == 3'b100);
	assign i_lhu 	= load && (funct3 == 3'b101);
	
	// Store instructions
	assign i_sb = store && (funct3 == 3'b000);
	assign i_sh = store && (funct3 == 3'b001);
	assign i_sw = store && (funct3 == 3'b010);
	
	// Register-immediate instructions
	assign i_addi 	= reg_imm && (funct3 == 3'b000);
	assign i_slti 	= reg_imm && (funct3 == 3'b010);
	assign i_sltiu = reg_imm && (funct3 == 3'b011);
	assign i_xori	= reg_imm && (funct3 == 3'b100);
	assign i_ori	= reg_imm && (funct3 == 3'b110);
	assign i_andi	= reg_imm && (funct3 == 3'b111);
	assign i_slli	= reg_imm && (funct3 == 3'b001);
	assign i_srli	= reg_imm && (funct3 == 3'b101) && (funct7 == 7'b0000000);
	assign i_srai	= reg_imm && (funct3 == 3'b101) && (funct7 == 7'b0100000);
	
	// Register-register instructions
	assign i_add 	= reg_reg && (funct3 == 3'b000) && (funct7 == 7'b0000000);
	assign i_sub 	= reg_reg && (funct3 == 3'b000) && (funct7 == 7'b0100000);
	assign i_sll 	= reg_reg && (funct3 == 3'b001);
	assign i_slt 	= reg_reg && (funct3 == 3'b010);
	assign i_sltu 	= reg_reg && (funct3 == 3'b011);
	assign i_xor 	= reg_reg && (funct3 == 3'b100);
	assign i_srl 	= reg_reg && (funct3 == 3'b101) && (funct7 == 7'b0000000);
	assign i_sra 	= reg_reg && (funct3 == 3'b101) && (funct7 == 7'b0100000);
	assign i_or 	= reg_reg && (funct3 == 3'b110);
	assign i_and 	= reg_reg && (funct3 == 3'b111);

	localparam I_TYPE = 3'b0;
	localparam S_TYPE = 3'b001;
	localparam B_TYPE = 3'b010;
	localparam U_TYPE = 3'b011;
	localparam J_TYPE = 3'b100;
	
	// Determine instruction type
	logic [2:0] i_type;
	always_comb begin
		if (reg_imm) // I
			i_type = I_TYPE;
		else if (store) // S
			i_type = S_TYPE;
		else if (branch) // B
			i_type = B_TYPE;
		else if (i_lui || i_auipc) // U
			i_type = U_TYPE;
		else if (i_jal) // J
			i_type = J_TYPE;
		else
			i_type = I_TYPE;
	end
	
	// Immediate generation
	imm_gen ig (.i_type(i_type), .instruction(instruction), .immediate(immediate));
	
	// Determine control flags
	// cf_reg_write, cf_mem_to_reg, cf_alu_op, cf_alu_src, cf_slt, cf_shift, cf_shift_type
	assign reg_write = (i_lui || i_auipc || i_jal || i_jalr || i_lb || i_lh || i_lw || i_lbu || i_lhu || i_addi || i_slti || i_sltiu ||
								i_xori || i_ori || i_andi || i_slli || i_srli || i_srai || i_add || i_sub || i_sll ||
								i_slt || i_sltu || i_xor || i_srl || i_sra || i_or || i_and);
	always_comb begin
		if (i_auipc || i_lb || i_lh || i_lw || i_lbu || i_lhu || i_sb || i_sh || i_sw || i_addi || i_add)
			alu_op = 0;
		else if (i_beq || i_bne || i_blt || i_bge || i_bltu || i_bgeu || i_slti || i_sltiu || i_sub || i_slt || i_sltu)
			alu_op = 1;
		else if (i_xori || i_xor)
			alu_op = 2;
		else if (i_ori || i_or)
			alu_op = 3;
		else if (i_andi || i_and)
			alu_op = 4;
		else if (i_lui)
			alu_op = 5;
		else
			alu_op = 0;
	end
	assign alu_src = (i_lui || i_auipc || i_lb || i_lh || i_lw || i_lbu || i_lhu || i_sb || i_sh || i_sw || i_addi || i_slti || i_sltiu ||
							i_xori || i_ori || i_andi || i_slli || i_srli || i_srai);
	assign auipc = i_auipc;
	assign shift = (i_slli || i_srli || i_srai || i_sll || i_srl || i_sra);
	always_comb begin
		if (i_slli || i_sll)
			shift_type = 0;
		else if (i_srli || i_srl)
			shift_type = 1;
		else if (i_srai || i_sra)
			shift_type = 2;
		else
			shift_type = 0;
	end
	assign slt = (i_slti || i_sltiu || i_slt || i_sltu);
	assign mem_write = (i_sb || i_sh || i_sw);
	assign mem_read = (i_lb || i_lh || i_lw || i_lbu || i_lhu);
	always_comb begin
		if (i_lb || i_lbu || i_sb)
			xfer_size = 1;
		else if (i_lh || i_lhu || i_sh)
			xfer_size = 2;
		else if (i_lw || i_sw)
			xfer_size = 4;
		else
			xfer_size = 4;
	end
	assign mem_to_reg = (i_lb || i_lh || i_lw || i_lbu || i_lhu);
	assign jump = (i_jal || i_jalr);
	assign jalr = i_jalr;
	always_comb begin
		if (i_beq)
			branch_type = 1;
		else if (i_bne)
			branch_type = 2;
		else if (i_blt)
			branch_type = 3;
		else if (i_bge)
			branch_type = 4;
		else if (i_bltu)
			branch_type = 5;
		else if (i_bgeu)
			branch_type = 6;
		else
			branch_type = 0;
	end
	assign is_unsigned = (i_bltu || i_bgeu || i_lbu || i_lhu || i_sltiu || i_sltu);
endmodule

module control_tb ();

endmodule
