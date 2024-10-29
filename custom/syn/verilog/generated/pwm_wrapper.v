module pwm_wrapper (
	clk_i,
	rst_ni,
	device_req_i,
	device_addr_i,
	device_we_i,
	device_be_i,
	device_wdata_i,
	device_rvalid_o,
	device_rdata_o,
	pwm_o
);
	parameter signed [31:0] PwmWidth = 12;
	parameter signed [31:0] PwmCtrSize = 8;
	parameter signed [31:0] BusAddrWidth = 32;
	parameter signed [31:0] BusDataWidth = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire device_req_i;
	input wire [BusAddrWidth - 1:0] device_addr_i;
	input wire device_we_i;
	input wire [3:0] device_be_i;
	input wire [BusDataWidth - 1:0] device_wdata_i;
	output reg device_rvalid_o;
	output wire [BusDataWidth - 1:0] device_rdata_o;
	output wire [PwmWidth - 1:0] pwm_o;
	localparam [31:0] AddrWidth = 10;
	localparam [31:0] PwmIdxOffset = $clog2(BusAddrWidth / 8) + 1;
	localparam [31:0] PwmIdxWidth = AddrWidth - PwmIdxOffset;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < PwmWidth; _gv_i_1 = _gv_i_1 + 1) begin : gen_pwm
			localparam i = _gv_i_1;
			wire [PwmCtrSize - 1:0] data_d;
			reg [PwmCtrSize - 1:0] counter_q;
			reg [PwmCtrSize - 1:0] pulse_width_q;
			wire counter_en;
			wire pulse_width_en;
			wire [PwmIdxWidth - 1:0] pwm_idx;
			assign pwm_idx = i;
			assign data_d = device_wdata_i[PwmCtrSize - 1:0];
			assign counter_en = ((device_req_i & device_we_i) & (device_addr_i[9:PwmIdxOffset] == pwm_idx)) & device_addr_i[PwmIdxOffset - 1];
			assign pulse_width_en = ((device_req_i & device_we_i) & (device_addr_i[9:PwmIdxOffset] == pwm_idx)) & ~device_addr_i[PwmIdxOffset - 1];
			always @(posedge clk_i or negedge rst_ni)
				if (!rst_ni) begin
					counter_q <= 1'sb0;
					pulse_width_q <= 1'sb0;
				end
				else begin
					if (counter_en)
						counter_q <= data_d;
					if (pulse_width_en)
						pulse_width_q <= data_d;
				end
			pwm #(.CtrSize(PwmCtrSize)) u_pwm(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.pulse_width_i(pulse_width_q),
				.max_counter_i(counter_q),
				.modulated_o(pwm_o[i])
			);
		end
	endgenerate
	assign device_rdata_o = 32'b00000000000000000000000000000000;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni)
			device_rvalid_o <= 1'b0;
		else
			device_rvalid_o <= device_req_i;
	wire _unused;
	assign _unused = ^device_be_i ^ ^device_wdata_i;
endmodule
