module top (
	input logic clk, RESET,
	input logic [3:0] KEY,
	output logic [3:0] LEDR, DIG,
	output logic UART_TXD
	);
	
//	logic 			instuction_valid;
//	logic [31:0]	instruction_addr;
//	logic [31:0]   instruction_read;
//	logic          instruction_ready;
//	logic          instruction_ack;
//
//	logic          data_read_valid;
//	logic          data_write_valid;
//	logic [31:0]   data_addr;
//	logic [31:0]   data_read;
//	logic [31:0]   data_write;
//	logic [3:0]    data_write_byte;
//	logic          data_ready;
//	logic          data_ack;
	
	logic reset;
	assign reset = ~RESET;
	
	assign LEDR = KEY;
	assign DIG[3:0] = 0;
	
	logic data_write;
	logic [31:0] data_address, data;
	
	cpu c (.clk, .reset, .data_write, .data_address, .data);
	
	always_comb begin
		if (data_write && (data_address == 'h0002FFF8))
			$write("%c", data[7:0]);
	end
	
	logic tx_ready, empty;
	logic [7:0] fifo_out;
	uart_tx utx (.clk, .reset(reset), .tx_data_ready(~empty), .tx_data(fifo_out), .txd(UART_TXD), .tx_ready);
	
	FIFO #(.DEPTH(200)) fifo (.clk, .reset, .read(tx_ready), .write(data_write && (data_address == 'h2FFF8)), .inputBus(data[7:0]), .empty, .full(), .outputBus(fifo_out));
	
	
	// RESET = 1 when unpressed, 0 when pressed
	
	// TEST CODE FOR UART
//	logic [7:0] tx_data;
//	logic tx_data_ready, tx_ready;
//	
//	uart_tx utx (.clk, .reset(reset), .tx_data_ready(tx_data_ready), .tx_data(tx_data), .txd(UART_TXD), .tx_ready(tx_ready));
	
//	`define text "Hello world!\r\n"
//	logic [$bits(`text)-1:0] serial_string_buf;
//	localparam text_len = $bits(serial_string_buf);
//	logic last_tx_ready;
//
//	assign tx_data_ready = 1'b1;
//	assign tx_data = serial_string_buf[text_len-1:text_len-8];
//
//	always_ff @(posedge clk) begin
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

`ifndef LINT
module top_tb ();
	logic clk, RESET;
	logic [3:0] KEY;
	logic [3:0] LEDR, DIG;
	logic UART_TXD;
	
	top dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end
	
	initial begin
		RESET <= 0; @(posedge clk);
		RESET <= 1; @(posedge clk);
		for (int i = 0; i < 100000; i++)
			@(posedge clk);
		$stop;
	end
endmodule
`endif
