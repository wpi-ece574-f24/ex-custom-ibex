module myreg (
	clk_i,
	rst_ni,
	device_req_i,
	device_addr_i,
	device_we_i,
	device_be_i,
	device_wdata_i,
	device_rvalid_o,
	device_rdata_o
);
	reg _sv2v_0;
	parameter [31:0] AddrWidth = 32;
	parameter [31:0] RegAddr = 8;
	input wire clk_i;
	input wire rst_ni;
	input wire device_req_i;
	input wire [AddrWidth - 1:0] device_addr_i;
	input wire device_we_i;
	input wire [3:0] device_be_i;
	input wire [31:0] device_wdata_i;
	output reg device_rvalid_o;
	output reg [31:0] device_rdata_o;
	localparam [31:0] MYREG_REG1 = 32'h00000000;
	localparam [31:0] MYREG_REG2 = 32'h00000004;
	wire [RegAddr - 1:0] reg_addr;
	wire reg1_wr;
	wire reg1_rd;
	wire reg2_wr;
	wire reg2_rd;
	reg [31:0] reg1_data;
	reg [31:0] reg2_data;
	assign reg_addr = device_addr_i[RegAddr - 1:0];
	assign reg1_wr = (device_req_i & device_we_i) & (reg_addr == MYREG_REG1[RegAddr - 1:0]);
	assign reg1_rd = (device_req_i & ~device_we_i) & (reg_addr == MYREG_REG1[RegAddr - 1:0]);
	assign reg2_wr = (device_req_i & device_we_i) & (reg_addr == MYREG_REG2[RegAddr - 1:0]);
	assign reg2_rd = (device_req_i & ~device_we_i) & (reg_addr == MYREG_REG2[RegAddr - 1:0]);
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			reg1_data <= 32'b00000000000000000000000000000000;
			reg2_data <= 32'b00000000000000000000000000000000;
		end
		else begin
			if (reg1_wr) begin
				reg1_data[7:0] <= {(device_be_i[0] ? device_wdata_i[7:0] : reg1_data[7:0])};
				reg1_data[15:8] <= {(device_be_i[1] ? device_wdata_i[15:8] : reg1_data[15:8])};
				reg1_data[23:16] <= {(device_be_i[2] ? device_wdata_i[23:16] : reg1_data[23:16])};
				reg1_data[31:24] <= {(device_be_i[3] ? device_wdata_i[31:24] : reg1_data[31:24])};
			end
			if (reg2_wr) begin
				reg2_data[7:0] <= {(device_be_i[0] ? device_wdata_i[7:0] : reg2_data[7:0])};
				reg2_data[15:8] <= {(device_be_i[1] ? device_wdata_i[15:8] : reg2_data[15:8])};
				reg2_data[23:16] <= {(device_be_i[2] ? device_wdata_i[23:16] : reg2_data[23:16])};
				reg2_data[31:24] <= {(device_be_i[3] ? device_wdata_i[31:24] : reg2_data[31:24])};
			end
			device_rvalid_o <= device_req_i;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (reg1_rd)
			device_rdata_o = reg1_data;
		else if (reg2_rd)
			device_rdata_o = reg2_data;
		else
			device_rdata_o = 32'b00000000000000000000000000000000;
	end
	wire [(AddrWidth - 1) - RegAddr:0] unused_device_addr;
	assign unused_device_addr = device_addr_i[AddrWidth - 1:RegAddr];
	initial _sv2v_0 = 0;
endmodule
