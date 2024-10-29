module gpio (
	clk_i,
	rst_ni,
	device_req_i,
	device_addr_i,
	device_we_i,
	device_be_i,
	device_wdata_i,
	device_rvalid_o,
	device_rdata_o,
	gp_i,
	gp_o
);
	reg _sv2v_0;
	parameter [31:0] GpiWidth = 8;
	parameter [31:0] GpoWidth = 16;
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
	output reg [DataWidth - 1:0] device_rdata_o;
	input wire [GpiWidth - 1:0] gp_i;
	output reg [GpoWidth - 1:0] gp_o;
	localparam [31:0] GPIO_OUT_REG = 32'h00000000;
	localparam [31:0] GPIO_IN_REG = 32'h00000004;
	localparam [31:0] GPIO_IN_DBNC_REG = 32'h00000008;
	wire [RegAddr - 1:0] reg_addr;
	reg [(3 * GpiWidth) - 1:0] gp_i_q;
	wire [GpiWidth - 1:0] gp_i_dbnc;
	wire [GpoWidth - 1:0] gp_o_d;
	wire gp_o_wr_en;
	wire gp_i_rd_en_d;
	reg gp_i_rd_en_q;
	wire gp_i_dbnc_rd_en_d;
	reg gp_i_dbnc_rd_en_q;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < GpiWidth; _gv_i_1 = _gv_i_1 + 1) begin : gen_debounce
			localparam i = _gv_i_1;
			debounce #(.ClkCount(500)) dbnc(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.btn_i(gp_i_q[(2 * GpiWidth) + i]),
				.btn_o(gp_i_dbnc[i])
			);
		end
	endgenerate
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			gp_i_q <= 1'sb0;
			gp_o <= 1'sb0;
			device_rvalid_o <= 1'sb0;
			gp_i_rd_en_q <= 1'sb0;
			gp_i_dbnc_rd_en_q <= 1'sb0;
		end
		else begin
			gp_i_q <= {gp_i_q[0+:GpiWidth * 2], gp_i};
			if (gp_o_wr_en)
				gp_o <= gp_o_d;
			device_rvalid_o <= device_req_i;
			gp_i_rd_en_q <= gp_i_rd_en_d;
			gp_i_dbnc_rd_en_q <= gp_i_dbnc_rd_en_d;
		end
	wire [3:0] unused_device_be;
	genvar _gv_i_byte_1;
	generate
		for (_gv_i_byte_1 = 0; _gv_i_byte_1 < 4; _gv_i_byte_1 = _gv_i_byte_1 + 1) begin : gen_gp_o_d
			localparam i_byte = _gv_i_byte_1;
			if ((i_byte * 8) < GpoWidth) begin : gen_gp_o_d_inner
				localparam signed [31:0] gpo_byte_end = (((i_byte + 1) * 8) <= GpoWidth ? (i_byte + 1) * 8 : GpoWidth);
				assign gp_o_d[gpo_byte_end - 1:i_byte * 8] = (device_be_i[i_byte] ? device_wdata_i[gpo_byte_end - 1:i_byte * 8] : gp_o[gpo_byte_end - 1:i_byte * 8]);
				assign unused_device_be[i_byte] = 0;
			end
			else begin : gen_unused_device_be
				assign unused_device_be[i_byte] = device_be_i[i_byte];
			end
		end
	endgenerate
	assign reg_addr = device_addr_i[RegAddr - 1:0];
	assign gp_o_wr_en = (device_req_i & device_we_i) & (reg_addr == GPIO_OUT_REG[RegAddr - 1:0]);
	assign gp_i_rd_en_d = (device_req_i & ~device_we_i) & (reg_addr == GPIO_IN_REG[RegAddr - 1:0]);
	assign gp_i_dbnc_rd_en_d = (device_req_i & ~device_we_i) & (reg_addr == GPIO_IN_DBNC_REG[RegAddr - 1:0]);
	always @(*) begin
		if (_sv2v_0)
			;
		if (gp_i_dbnc_rd_en_q)
			device_rdata_o = {{DataWidth - GpiWidth {1'b0}}, gp_i_dbnc};
		else if (gp_i_rd_en_q)
			device_rdata_o = {{DataWidth - GpiWidth {1'b0}}, gp_i_q[2 * GpiWidth+:GpiWidth]};
		else
			device_rdata_o = {{DataWidth - GpoWidth {1'b0}}, gp_o};
	end
	wire [(AddrWidth - 1) - RegAddr:0] unused_device_addr;
	wire [(DataWidth - 1) - GpoWidth:0] unused_device_wdata;
	assign unused_device_addr = device_addr_i[AddrWidth - 1:RegAddr];
	assign unused_device_wdata = device_wdata_i[DataWidth - 1:GpoWidth];
	initial _sv2v_0 = 0;
endmodule
