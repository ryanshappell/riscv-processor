module top (
	input logic FPGA_CLK, RESET,
	input logic [3:0] KEY,
	output logic [3:0] LEDR, DIG,
	output logic UART_TXD
	);
	
	logic 			instuction_valid;
	logic [31:0]	instruction_addr;
	logic [31:0]   instruction_read;
	logic          instruction_ready;
	logic          instruction_ack;

	logic          data_read_valid;
	logic          data_write_valid;
	logic [31:0]   data_addr;
	logic [31:0]   data_read;
	logic [31:0]   data_write;
	logic [3:0]    data_write_byte;
	logic          data_ready;
	logic          data_ack;
	
	logic reset;
	assign reset = ~RESET;
	
	assign LEDR[3:1] = 3'b111;
	assign DIG[3:0] = 0;
	
	// RESET = 1 when unpressed, 0 when pressed
	
	// TEST CODE FOR UART
//	logic [7:0] tx_data;
//	logic tx_data_ready, tx_ready;
//	
//	uart_tx utx (.clk(FPGA_CLK), .reset(reset), .tx_data_ready(tx_data_ready), .tx_data(tx_data), .txd(UART_TXD), .tx_ready(tx_ready));
//	
//	`define text "Hello world!\r\n"
//	logic [$bits(`text)-1:0] serial_string_buf;
//	localparam text_len = $bits(serial_string_buf);
//	logic last_tx_ready;
//
//	assign tx_data_ready = 1'b1;
//	assign tx_data = serial_string_buf[text_len-1:text_len-8];
//
//	always_ff @(posedge FPGA_CLK) begin
//		if (reset) begin
//			serial_string_buf <= `text;
//			last_tx_ready <= 1'b0;
//		end else if (tx_ready && !last_tx_ready) begin
//			serial_string_buf <= { serial_string_buf[text_len-8-1:0], serial_string_buf[text_len-1:text_len-8] };
//			last_tx_ready <= tx_ready;
//		end else begin
//			serial_string_buf <= serial_string_buf;
//			last_tx_ready <= tx_ready;
//		end
//	end
endmodule
