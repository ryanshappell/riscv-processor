module top (
	input logic clk, RESET,
	input logic [3:0] KEY,
	output logic [3:0] LEDR, DIG,
	output logic UART_TXD
	);
	
	logic reset;
	assign reset = ~RESET;
	
	assign LEDR = KEY;
	assign DIG[3:0] = 0;
	
	logic data_write;
	logic [7:0] data;
	logic [31:0] data_address;
	
	cpu c (.clk, .reset, .data_write, .data_address, .data);
	
	// Test printout for sim
	always_comb begin
		if (data_write && (data_address == 'h0002FFF8))
			$write("%c", data[7:0]);
	end
	
	logic tx_ready, empty;
	logic [7:0] fifo_out;
	uart_tx utx (.clk, .reset(reset), .tx_data_ready(~empty), .tx_data(fifo_out), .txd(UART_TXD), .tx_ready);
	
	// verilator lint_off PINCONNECTEMPTY
	FIFO fifo (.clk, .reset, .read(tx_ready), .write(data_write && (data_address == 'h2FFF8)), .inputBus(data[7:0]), .empty, .full(), .outputBus(fifo_out));
	// verilator lint_on PINCONNECTEMPTY
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
