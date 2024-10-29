module spi_host (
	clk_i,
	rst_ni,
	spi_rx_i,
	spi_tx_o,
	sck_o,
	start_i,
	byte_data_i,
	byte_data_o,
	next_tx_byte_o
);
	reg _sv2v_0;
	parameter [31:0] ClockFrequency = 50000000;
	parameter [31:0] BaudRate = 12500000;
	parameter [0:0] CPOL = 0;
	parameter [0:0] CPHA = 0;
	input clk_i;
	input rst_ni;
	input wire spi_rx_i;
	output reg spi_tx_o;
	output wire sck_o;
	input wire start_i;
	input wire [7:0] byte_data_i;
	output reg [7:0] byte_data_o;
	output reg next_tx_byte_o;
	localparam [31:0] ClocksPerBaud = ClockFrequency / BaudRate;
	localparam [31:0] ToggleCount = ClocksPerBaud / 2;
	localparam [31:0] CountWidth = $clog2(ToggleCount);
	wire [CountWidth - 1:0] limit;
	reg [CountWidth - 1:0] count;
	reg sck;
	wire count_at_limit;
	wire sck_pos;
	wire sck_neg;
	wire sck_en;
	reg [1:0] state_q;
	assign sck_en = state_q == 2'd2;
	function automatic [CountWidth - 1:0] sv2v_cast_5AF1A;
		input reg [CountWidth - 1:0] inp;
		sv2v_cast_5AF1A = inp;
	endfunction
	assign limit = sv2v_cast_5AF1A(ToggleCount - 1);
	assign count_at_limit = count >= limit;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			count <= 1'sb0;
			sck <= CPOL;
		end
		else if (!(sck_en || start_i)) begin
			count <= 1'sb0;
			sck <= CPOL;
		end
		else if (count_at_limit) begin
			count <= 1'sb0;
			sck <= ~sck;
		end
		else
			count <= count + 1'b1;
	assign sck_o = (sck_en ? sck : CPOL);
	assign sck_pos = count_at_limit && !sck;
	assign sck_neg = count_at_limit && sck;
	reg [1:0] state_d;
	reg [2:0] bit_counter_q;
	reg [2:0] bit_counter_d;
	reg [7:0] current_byte_q;
	reg [7:0] current_byte_d;
	reg [7:0] recieved_byte_d;
	reg [7:0] recieved_byte_q;
	always @(*) begin
		if (_sv2v_0)
			;
		spi_tx_o = 1'b1;
		bit_counter_d = bit_counter_q;
		current_byte_d = current_byte_q;
		next_tx_byte_o = 1'b0;
		state_d = state_q;
		byte_data_o = 1'sb0;
		case (state_q)
			2'd0: begin
				spi_tx_o = 1'b1;
				if (start_i)
					state_d = 2'd1;
			end
			2'd1: begin
				state_d = 2'd2;
				bit_counter_d = 3'd7;
				current_byte_d = byte_data_i;
			end
			2'd2: begin
				spi_tx_o = current_byte_q[7];
				current_byte_d = {current_byte_q[6:0], 1'b0};
				if (bit_counter_q == 3'd0)
					state_d = 2'd3;
				else
					bit_counter_d = bit_counter_q - 3'd1;
			end
			2'd3: begin
				spi_tx_o = 1'b1;
				next_tx_byte_o = 1'b1;
				byte_data_o = recieved_byte_q;
				state_d = 2'd0;
			end
		endcase
	end
	generate
		if (CPHA) begin : gen_cpha
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni) begin
					current_byte_q <= 1'sb0;
					bit_counter_q <= 1'sb0;
					recieved_byte_q <= 1'sb0;
					state_q <= 2'd0;
				end
				else if (sck_pos) begin
					bit_counter_q <= bit_counter_d;
					recieved_byte_q <= recieved_byte_d;
					state_q <= state_d;
				end
				else if (sck_neg) begin
					current_byte_q <= current_byte_d;
					if (state_q == 2'd2)
						recieved_byte_d <= {recieved_byte_q[6:0], spi_rx_i};
				end
		end
		else begin : gen_no_cpha
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni) begin
					current_byte_q <= 1'sb0;
					bit_counter_q <= 1'sb0;
					recieved_byte_q <= 1'sb0;
					state_q <= 2'd0;
				end
				else if (sck_pos) begin
					current_byte_q <= current_byte_d;
					if (state_q == 2'd2)
						recieved_byte_d <= {recieved_byte_q[6:0], spi_rx_i};
				end
				else if (sck_neg) begin
					bit_counter_q <= bit_counter_d;
					recieved_byte_q <= recieved_byte_d;
					state_q <= state_d;
				end
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
