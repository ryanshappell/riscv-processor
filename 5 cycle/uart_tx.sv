module uart_tx (
	input logic clk, reset, tx_data_ready,
	input logic [7:0] tx_data,
	output logic txd, tx_ready
	);
	
	localparam baud_period = 5208; // (50e6/9600 = 5208)

	logic [3:0] data_shift_buffer_remaining;
	logic [9:0] data_shift_buffer;

	assign tx_ready = data_shift_buffer_remaining == 4'b0;
	assign txd = data_shift_buffer[0];

	logic [12:0] clock_divider;
	always_ff @(posedge clk) begin
		clock_divider <= (clock_divider == (baud_period-1)) ? 0 : clock_divider + 1;

		data_shift_buffer <= data_shift_buffer;
		data_shift_buffer_remaining <= data_shift_buffer_remaining;

		if (reset) begin
			data_shift_buffer <= {10{ 1'b1 }};
			data_shift_buffer_remaining <= 0;
			clock_divider <= 0;
		end else if (tx_data_ready && tx_ready) begin
			data_shift_buffer <= { 1'b1, tx_data, 1'b0 };
			data_shift_buffer_remaining <= 10;
		end else if (clock_divider == 0) begin
			if (data_shift_buffer_remaining > 0) begin
				 data_shift_buffer <= { 1'b1, data_shift_buffer[9:1] };
				 data_shift_buffer_remaining <= data_shift_buffer_remaining - 1;
			end
		end
	end
endmodule
