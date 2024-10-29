module uart (
	clk_i,
	rst_ni,
	device_req_i,
	device_addr_i,
	device_we_i,
	device_be_i,
	device_wdata_i,
	device_rvalid_o,
	device_rdata_o,
	uart_rx_i,
	uart_irq_o,
	uart_tx_o
);
	reg _sv2v_0;
	parameter [31:0] ClockFrequency = 50000000;
	parameter [31:0] BaudRate = 115200;
	parameter [31:0] RxFifoDepth = 128;
	parameter [31:0] TxFifoDepth = 128;
	parameter [31:0] AddrWidth = 32;
	parameter [31:0] DataWidth = 32;
	parameter [31:0] RegAddr = 12;
	input wire clk_i;
	input wire rst_ni;
	input wire device_req_i;
	input wire [AddrWidth - 1:0] device_addr_i;
	input wire device_we_i;
	input wire [3:0] device_be_i;
	input wire [DataWidth - 1:0] device_wdata_i;
	output wire device_rvalid_o;
	output wire [DataWidth - 1:0] device_rdata_o;
	input wire uart_rx_i;
	output wire uart_irq_o;
	output reg uart_tx_o;
	localparam [31:0] ClocksPerBaud = ClockFrequency / BaudRate;
	function automatic [RegAddr - 1:0] sv2v_cast_33151;
		input reg [RegAddr - 1:0] inp;
		sv2v_cast_33151 = inp;
	endfunction
	localparam [RegAddr - 1:0] UartRxReg = sv2v_cast_33151('h0);
	localparam [RegAddr - 1:0] UartTxReg = sv2v_cast_33151('h4);
	localparam [RegAddr - 1:0] UartStatusReg = sv2v_cast_33151('h8);
	reg [DataWidth - 1:0] device_rdata_d;
	reg [DataWidth - 1:0] device_rdata_q;
	reg device_rvalid_d;
	reg device_rvalid_q;
	wire [RegAddr - 1:0] reg_addr;
	reg [$clog2(ClocksPerBaud) - 1:0] rx_baud_counter_q;
	wire [$clog2(ClocksPerBaud) - 1:0] rx_baud_counter_d;
	wire rx_baud_tick;
	reg [1:0] rx_state_q;
	reg [1:0] rx_state_d;
	reg [2:0] rx_bit_counter_q;
	reg [2:0] rx_bit_counter_d;
	reg [7:0] rx_current_byte_q;
	reg [7:0] rx_current_byte_d;
	reg [2:0] rx_q;
	wire rx_start;
	reg rx_valid;
	wire rx_fifo_wvalid;
	reg rx_fifo_rready;
	wire [7:0] rx_fifo_rdata;
	wire rx_fifo_rvalid;
	wire rx_fifo_empty;
	reg [$clog2(ClocksPerBaud) - 1:0] tx_baud_counter_q;
	wire [$clog2(ClocksPerBaud) - 1:0] tx_baud_counter_d;
	wire tx_baud_tick;
	wire write_req;
	reg [1:0] tx_state_q;
	reg [1:0] tx_state_d;
	reg [2:0] tx_bit_counter_q;
	reg [2:0] tx_bit_counter_d;
	reg [7:0] tx_current_byte_q;
	reg [7:0] tx_current_byte_d;
	reg tx_next_byte;
	wire tx_fifo_wvalid;
	wire tx_fifo_rvalid;
	wire tx_fifo_rready;
	wire [7:0] tx_fifo_rdata;
	wire tx_fifo_full;
	assign reg_addr = device_addr_i[RegAddr - 1:0];
	function automatic [((DataWidth - 9) >= 0 ? DataWidth - 8 : 10 - DataWidth) - 1:0] sv2v_cast_7CD3F;
		input reg [((DataWidth - 9) >= 0 ? DataWidth - 8 : 10 - DataWidth) - 1:0] inp;
		sv2v_cast_7CD3F = inp;
	endfunction
	function automatic [((DataWidth - 3) >= 0 ? DataWidth - 2 : 4 - DataWidth) - 1:0] sv2v_cast_7582B;
		input reg [((DataWidth - 3) >= 0 ? DataWidth - 2 : 4 - DataWidth) - 1:0] inp;
		sv2v_cast_7582B = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		device_rdata_d = 1'sb0;
		device_rvalid_d = 1'b0;
		rx_fifo_rready = 1'b0;
		if (device_req_i) begin
			device_rvalid_d = 1'b1;
			if (device_be_i[0] & ~device_we_i)
				case (reg_addr)
					UartRxReg: begin
						device_rdata_d = {sv2v_cast_7CD3F(1'sb0), rx_fifo_rdata};
						rx_fifo_rready = 1'b1;
					end
					UartTxReg: device_rdata_d = 1'sb0;
					UartStatusReg: device_rdata_d = {sv2v_cast_7582B(1'sb0), tx_fifo_full, rx_fifo_empty};
					default: device_rdata_d = 1'sb0;
				endcase
		end
	end
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			device_rdata_q <= 1'sb0;
			device_rvalid_q <= 1'b0;
		end
		else begin
			device_rdata_q <= device_rdata_d;
			device_rvalid_q <= device_rvalid_d;
		end
	assign device_rdata_o = device_rdata_q;
	assign device_rvalid_o = device_rvalid_q;
	assign rx_fifo_wvalid = rx_baud_tick & rx_valid;
	assign rx_fifo_empty = ~rx_fifo_rvalid;
	function automatic [$clog2(ClocksPerBaud) - 1:0] sv2v_cast_959C6;
		input reg [$clog2(ClocksPerBaud) - 1:0] inp;
		sv2v_cast_959C6 = inp;
	endfunction
	assign rx_baud_counter_d = (rx_baud_tick ? {$clog2(ClocksPerBaud) {1'sb0}} : (rx_start ? sv2v_cast_959C6(ClocksPerBaud >> 1) : rx_baud_counter_q + 1'b1));
	assign rx_baud_tick = rx_baud_counter_q == sv2v_cast_959C6(ClocksPerBaud - 1);
	prim_fifo_sync #(
		.Width(8),
		.Pass(1'b0),
		.Depth(RxFifoDepth)
	) u_rx_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clr_i(1'b0),
		.wvalid_i(rx_fifo_wvalid),
		.wready_o(),
		.wdata_i(rx_current_byte_q),
		.rvalid_o(rx_fifo_rvalid),
		.rready_i(rx_fifo_rready),
		.rdata_o(rx_fifo_rdata),
		.full_o(),
		.depth_o(),
		.err_o()
	);
	assign uart_irq_o = !rx_fifo_empty;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			rx_q <= 1'sb0;
		else
			rx_q <= {rx_q[1:0], uart_rx_i};
	assign rx_start = (!rx_q[1] & rx_q[2]) & (rx_state_q == 2'd0);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			rx_baud_counter_q <= 1'sb0;
		else
			rx_baud_counter_q <= rx_baud_counter_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			rx_state_q <= 2'd0;
			rx_bit_counter_q <= 1'sb0;
			rx_current_byte_q <= 1'sb0;
		end
		else if (rx_start || rx_baud_tick) begin
			rx_state_q <= rx_state_d;
			rx_bit_counter_q <= rx_bit_counter_d;
			rx_current_byte_q <= rx_current_byte_d;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		rx_valid = 0;
		rx_bit_counter_d = rx_bit_counter_q;
		rx_current_byte_d = rx_current_byte_q;
		rx_state_d = rx_state_q;
		case (rx_state_q)
			2'd0:
				if (rx_start)
					rx_state_d = 2'd1;
			2'd1: begin
				rx_current_byte_d = 1'sb0;
				rx_bit_counter_d = 1'sb0;
				if (!rx_q[2])
					rx_state_d = 2'd2;
				else
					rx_state_d = 2'd0;
			end
			2'd2: begin
				rx_current_byte_d = {rx_q[2], rx_current_byte_q[7:1]};
				if (rx_bit_counter_q == 3'd7)
					rx_state_d = 2'd3;
				else
					rx_bit_counter_d = rx_bit_counter_q + 3'd1;
			end
			2'd3: begin
				if (rx_q[2])
					rx_valid = 1;
				rx_state_d = 2'd0;
			end
		endcase
	end
	assign write_req = (device_req_i & device_be_i[0]) & device_we_i;
	assign tx_fifo_wvalid = (reg_addr == UartTxReg) & write_req;
	assign tx_fifo_rready = tx_baud_tick & tx_next_byte;
	assign tx_baud_counter_d = (tx_baud_tick ? {$clog2(ClocksPerBaud) {1'sb0}} : tx_baud_counter_q + 1'b1);
	assign tx_baud_tick = tx_baud_counter_q == sv2v_cast_959C6(ClocksPerBaud - 1);
	prim_fifo_sync #(
		.Width(8),
		.Pass(1'b0),
		.Depth(TxFifoDepth)
	) u_tx_fifo(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.clr_i(1'b0),
		.wvalid_i(tx_fifo_wvalid),
		.wready_o(),
		.wdata_i(device_wdata_i[7:0]),
		.rvalid_o(tx_fifo_rvalid),
		.rready_i(tx_fifo_rready),
		.rdata_o(tx_fifo_rdata),
		.full_o(tx_fifo_full),
		.depth_o(),
		.err_o()
	);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			tx_baud_counter_q <= 1'sb0;
		else
			tx_baud_counter_q <= tx_baud_counter_d;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			tx_state_q <= 2'd0;
			tx_bit_counter_q <= 1'sb0;
			tx_current_byte_q <= 1'sb0;
		end
		else if (tx_baud_tick) begin
			tx_state_q <= tx_state_d;
			tx_bit_counter_q <= tx_bit_counter_d;
			tx_current_byte_q <= tx_current_byte_d;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		uart_tx_o = 1'b0;
		tx_bit_counter_d = tx_bit_counter_q;
		tx_current_byte_d = tx_current_byte_q;
		tx_next_byte = 1'b0;
		tx_state_d = tx_state_q;
		case (tx_state_q)
			2'd0: begin
				uart_tx_o = 1'b1;
				if (tx_fifo_rvalid)
					tx_state_d = 2'd1;
			end
			2'd1: begin
				uart_tx_o = 1'b0;
				tx_state_d = 2'd2;
				tx_bit_counter_d = 3'd0;
				tx_current_byte_d = tx_fifo_rdata;
				tx_next_byte = 1'b1;
			end
			2'd2: begin
				uart_tx_o = tx_current_byte_q[0];
				tx_current_byte_d = {1'b0, tx_current_byte_q[7:1]};
				if (tx_bit_counter_q == 3'd7)
					tx_state_d = 2'd3;
				else
					tx_bit_counter_d = tx_bit_counter_q + 3'd1;
			end
			2'd3: begin
				uart_tx_o = 1'b1;
				if (tx_fifo_rvalid)
					tx_state_d = 2'd1;
				else
					tx_state_d = 2'd0;
			end
		endcase
	end
	wire [(AddrWidth - 1) - RegAddr:0] unused_device_addr;
	wire [3:1] unused_device_be;
	wire [DataWidth - 9:0] unused_device_wdata;
	assign unused_device_addr = device_addr_i[AddrWidth - 1:RegAddr];
	assign unused_device_be = device_be_i[3:1];
	assign unused_device_wdata = device_wdata_i[DataWidth - 1:8];
	initial _sv2v_0 = 0;
endmodule
