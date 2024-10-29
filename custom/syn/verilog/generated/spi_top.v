module spi_top (
	clk_i,
	rst_ni,
	device_req_i,
	device_addr_i,
	device_we_i,
	device_be_i,
	device_wdata_i,
	device_rvalid_o,
	device_rdata_o,
	spi_rx_i,
	spi_tx_o,
	sck_o,
	byte_data_o
);
	parameter [31:0] ClockFrequency = 50000000;
	parameter [31:0] BaudRate = 12500000;
	parameter [0:0] CPOL = 0;
	parameter [0:0] CPHA = 0;
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
	output reg device_rvalid_o;
	output wire [DataWidth - 1:0] device_rdata_o;
	input wire spi_rx_i;
	output wire spi_tx_o;
	output wire sck_o;
	output wire [7:0] byte_data_o;
	function automatic [RegAddr - 1:0] sv2v_cast_33151;
		input reg [RegAddr - 1:0] inp;
		sv2v_cast_33151 = inp;
	endfunction
	localparam [RegAddr - 1:0] SpiTxReg = sv2v_cast_33151('h0);
	localparam [RegAddr - 1:0] SpiStatusReg = sv2v_cast_33151('h4);
	wire [RegAddr - 1:0] reg_addr;
	reg read_status_q;
	wire read_status_d;
	wire next_tx_byte_d;
	reg next_tx_byte_q;
	wire tx_fifo_wvalid;
	wire tx_fifo_rvalid;
	wire tx_fifo_rready;
	wire [7:0] tx_fifo_rdata;
	wire tx_fifo_full;
	wire tx_fifo_empty;
	wire [6:0] tx_fifo_depth;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			next_tx_byte_q <= 1'sb0;
			device_rvalid_o <= 1'sb0;
		end
		else begin
			next_tx_byte_q <= next_tx_byte_d;
			device_rvalid_o <= device_req_i;
		end
	assign tx_fifo_rready = next_tx_byte_d && ~next_tx_byte_q;
	assign reg_addr = device_addr_i[RegAddr - 1:0];
	assign tx_fifo_empty = tx_fifo_depth == 0;
	assign tx_fifo_wvalid = ((device_req_i & (reg_addr == SpiTxReg)) & device_we_i) & device_be_i[0];
	assign read_status_d = (device_req_i & (reg_addr == SpiStatusReg)) & ~device_we_i;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			read_status_q <= 0;
		else
			read_status_q <= read_status_d;
	function automatic [((DataWidth - 3) >= 0 ? DataWidth - 2 : 4 - DataWidth) - 1:0] sv2v_cast_7582B;
		input reg [((DataWidth - 3) >= 0 ? DataWidth - 2 : 4 - DataWidth) - 1:0] inp;
		sv2v_cast_7582B = inp;
	endfunction
	function automatic [DataWidth - 1:0] sv2v_cast_8536A;
		input reg [DataWidth - 1:0] inp;
		sv2v_cast_8536A = inp;
	endfunction
	assign device_rdata_o = (read_status_q ? {sv2v_cast_7582B(1'sb0), tx_fifo_empty, tx_fifo_full} : sv2v_cast_8536A(1'sb0));
	prim_fifo_sync #(
		.Width(8),
		.Pass(1'b0),
		.Depth(127)
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
		.depth_o(tx_fifo_depth),
		.err_o()
	);
	spi_host #(
		.ClockFrequency(ClockFrequency),
		.BaudRate(BaudRate),
		.CPOL(CPOL),
		.CPHA(CPHA)
	) u_spi_host(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.spi_rx_i(spi_rx_i),
		.spi_tx_o(spi_tx_o),
		.sck_o(sck_o),
		.start_i(tx_fifo_rvalid),
		.byte_data_i(tx_fifo_rdata),
		.byte_data_o(byte_data_o),
		.next_tx_byte_o(next_tx_byte_d)
	);
	wire [(AddrWidth - 1) - RegAddr:0] unused_device_addr;
	wire [3:1] unused_device_be;
	wire [DataWidth - 9:0] unused_device_wdata;
	assign unused_device_addr = device_addr_i[AddrWidth - 1:RegAddr];
	assign unused_device_be = device_be_i[3:1];
	assign unused_device_wdata = device_wdata_i[DataWidth - 1:8];
endmodule
