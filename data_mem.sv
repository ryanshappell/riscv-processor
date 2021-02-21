module data_mem (
	// verilator lint_off UNUSED
	input logic clk, mem_write, mem_read, is_unsigned,
	// verilator lint_on UNUSED
	input logic [2:0] xfer_size,
	input logic [31:0] address, w_data,
	output logic [31:0] r_data
	);
	
	logic [3:0][7:0] mem [15:0]; // TODO: determine how many bytes are needed
	logic [3:0] byte_en;
	logic [3:0][7:0] word;
	
	logic [2:0] xfer_size_next;
	logic [31:0] address_next;

	initial begin
		$readmemh("data.hex", mem);
	end
	
	always_comb begin
		case (xfer_size)
			1: byte_en = (4'b1 << (address % 4)); // one of the 4 bytes enabled
			2: byte_en = (4'b11 << (2 * ((address % 4) / 2))); // 4'b1100 or 4'b0011
			4:	byte_en = 4'b1111;
			default: byte_en = 4'b1111;
		endcase
		
		case (xfer_size_next)
			1: begin
				if (is_unsigned)
					r_data = {24'b0, word[address_next % 4]};
				else
					r_data = {{24{word[address_next % 4][7]}}, word[address_next % 4]};
			end
			2: begin
				if (is_unsigned)
					r_data = {16'b0, word[2 * ((address_next % 4) / 2) + 1], word[2 * ((address_next % 4) / 2)]};
				else
					r_data = {{16{word[2 * ((address_next % 4) / 2) + 1][7]}}, word[2 * ((address_next % 4) / 2) + 1], word[2 * ((address_next % 4) / 2)]};
			end
			4: r_data = word;
			default: r_data = word;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (mem_write) begin
			case (xfer_size)
				1: begin
					if (byte_en[0]) mem[address / 4][0] <= w_data[7:0];
					if (byte_en[1]) mem[address / 4][1] <= w_data[7:0];
					if (byte_en[2]) mem[address / 4][2] <= w_data[7:0];
					if (byte_en[3]) mem[address / 4][3] <= w_data[7:0];
				end
				
				2: begin
					if (byte_en[0]) mem[address / 4][0] <= w_data[7:0];
					if (byte_en[1]) mem[address / 4][1] <= w_data[15:8];
					if (byte_en[2]) mem[address / 4][2] <= w_data[7:0];
					if (byte_en[3]) mem[address / 4][3] <= w_data[15:8];
				end
				
				4: begin
					if (byte_en[0]) mem[address / 4][0] <= w_data[7:0];
					if (byte_en[1]) mem[address / 4][1] <= w_data[15:8];
					if (byte_en[2]) mem[address / 4][2] <= w_data[23:16];
					if (byte_en[3]) mem[address / 4][3] <= w_data[31:24];
				end
				
				default: begin
					if (byte_en[0]) mem[address / 4][0] <= w_data[7:0];
					if (byte_en[1]) mem[address / 4][1] <= w_data[15:8];
					if (byte_en[2]) mem[address / 4][2] <= w_data[23:16];
					if (byte_en[3]) mem[address / 4][3] <= w_data[31:24];
				end
			endcase
		end
		word <= mem[address/4];
		xfer_size_next <= xfer_size;
		address_next <= address;
	end
endmodule

`ifndef LINT
module data_mem_tb ();
	logic clk, mem_write, mem_read, is_unsigned;
	logic [2:0] xfer_size;
	logic [31:0] address, w_data;
	logic [31:0] r_data;
	
	data_mem dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		mem_write <= 0; mem_read <= 0; xfer_size <= 4; address <= 0; w_data <= 32'b11011111000011011000011100111100; @(posedge clk);
		mem_write <= 1; mem_read <= 1; xfer_size <= 2; @(posedge clk);
		address <= 1; @(posedge clk);
		address <= 2; @(posedge clk);
		address <= 3; @(posedge clk);
		address <= 4; @(posedge clk);
		address <= 5; @(posedge clk);
		address <= 6; @(posedge clk);
		address <= 7; @(posedge clk);
		address <= 8; @(posedge clk);
//		address <= 4; @(posedge clk);
//		address <= 0; mem_write <= 1; xfer_size = 1; w_data <= 32'b11011111000011011000011100111100; @(posedge clk);
//		address <= 1; @(posedge clk);
//		address <= 2; @(posedge clk);
//		address <= 3; @(posedge clk);
//		address <= 4; @(posedge clk);
//		address <= 0; mem_write <= 1; xfer_size = 2; w_data <= 32'b0; @(posedge clk);
//		address <= 1; @(posedge clk);
//		address <= 2; @(posedge clk);
//		address <= 3; @(posedge clk);
//		address <= 4; @(posedge clk);
//		address <= 5; @(posedge clk);
//		address <= 6; @(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule
`endif
