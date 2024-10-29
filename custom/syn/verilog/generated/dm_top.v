module dm_top (
	clk_i,
	rst_ni,
	testmode_i,
	ndmreset_o,
	dmactive_o,
	debug_req_o,
	unavailable_i,
	device_req_i,
	device_we_i,
	device_addr_i,
	device_be_i,
	device_wdata_i,
	device_rdata_o,
	host_req_o,
	host_add_o,
	host_we_o,
	host_wdata_o,
	host_be_o,
	host_gnt_i,
	host_r_valid_i,
	host_r_rdata_i,
	tck_i,
	tms_i,
	trst_ni,
	td_i,
	td_o
);
	parameter signed [31:0] NrHarts = 1;
	parameter [31:0] IdcodeValue = 32'h00000001;
	parameter signed [31:0] BusWidth = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire testmode_i;
	output wire ndmreset_o;
	output wire dmactive_o;
	output wire [NrHarts - 1:0] debug_req_o;
	input wire [NrHarts - 1:0] unavailable_i;
	input wire device_req_i;
	input wire device_we_i;
	input wire [BusWidth - 1:0] device_addr_i;
	input wire [(BusWidth / 8) - 1:0] device_be_i;
	input wire [BusWidth - 1:0] device_wdata_i;
	output wire [BusWidth - 1:0] device_rdata_o;
	output wire host_req_o;
	output wire [BusWidth - 1:0] host_add_o;
	output wire host_we_o;
	output wire [BusWidth - 1:0] host_wdata_o;
	output wire [(BusWidth / 8) - 1:0] host_be_o;
	input wire host_gnt_i;
	input wire host_r_valid_i;
	input wire [BusWidth - 1:0] host_r_rdata_i;
	input wire tck_i;
	input wire tms_i;
	input wire trst_ni;
	input wire td_i;
	output wire td_o;
	localparam [NrHarts - 1:0] SelectableHarts = {NrHarts {1'b1}};
	wire [(NrHarts * 32) - 1:0] hartinfo;
	wire [NrHarts - 1:0] halted;
	wire [NrHarts - 1:0] resumeack;
	wire [NrHarts - 1:0] haltreq;
	wire [NrHarts - 1:0] resumereq;
	wire clear_resumeack;
	wire cmd_valid;
	wire [31:0] cmd;
	wire cmderror_valid;
	wire [2:0] cmderror;
	wire cmdbusy;
	localparam [4:0] dm_ProgBufSize = 5'h08;
	wire [255:0] progbuf;
	localparam [3:0] dm_DataCount = 4'h2;
	wire [63:0] data_csrs_mem;
	wire [63:0] data_mem_csrs;
	wire data_valid;
	wire [19:0] hartsel;
	wire [BusWidth - 1:0] sbaddress_csrs_sba;
	wire [BusWidth - 1:0] sbaddress_sba_csrs;
	wire sbaddress_write_valid;
	wire sbreadonaddr;
	wire sbautoincrement;
	wire [2:0] sbaccess;
	wire sbreadondata;
	wire [BusWidth - 1:0] sbdata_write;
	wire sbdata_read_valid;
	wire sbdata_write_valid;
	wire [BusWidth - 1:0] sbdata_read;
	wire sbdata_valid;
	wire sbbusy;
	wire sberror_valid;
	wire [2:0] sberror;
	wire ndmreset;
	wire [40:0] dmi_req;
	wire [33:0] dmi_rsp;
	wire dmi_req_valid;
	wire dmi_req_ready;
	wire dmi_rsp_valid;
	wire dmi_rsp_ready;
	wire dmi_rst_n;
	localparam [11:0] dm_DataAddr = 12'h380;
	localparam [31:0] DebugHartInfo = {16'h0021, dm_DataCount, dm_DataAddr};
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < NrHarts; _gv_i_1 = _gv_i_1 + 1) begin : gen_dm_hart_ctrl
			localparam i = _gv_i_1;
			assign hartinfo[i * 32+:32] = DebugHartInfo;
		end
	endgenerate
	assign ndmreset_o = ndmreset;
	dm_csrs #(
		.NrHarts(NrHarts),
		.BusWidth(BusWidth),
		.SelectableHarts(SelectableHarts)
	) i_dm_csrs(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.testmode_i(testmode_i),
		.dmi_rst_ni(dmi_rst_n),
		.dmi_req_valid_i(dmi_req_valid),
		.dmi_req_ready_o(dmi_req_ready),
		.dmi_req_i(dmi_req),
		.dmi_resp_valid_o(dmi_rsp_valid),
		.dmi_resp_ready_i(dmi_rsp_ready),
		.dmi_resp_o(dmi_rsp),
		.ndmreset_o(ndmreset),
		.dmactive_o(dmactive_o),
		.hartsel_o(hartsel),
		.hartinfo_i(hartinfo),
		.halted_i(halted),
		.unavailable_i(unavailable_i),
		.resumeack_i(resumeack),
		.haltreq_o(haltreq),
		.resumereq_o(resumereq),
		.clear_resumeack_o(clear_resumeack),
		.cmd_valid_o(cmd_valid),
		.cmd_o(cmd),
		.cmderror_valid_i(cmderror_valid),
		.cmderror_i(cmderror),
		.cmdbusy_i(cmdbusy),
		.progbuf_o(progbuf),
		.data_i(data_mem_csrs),
		.data_valid_i(data_valid),
		.data_o(data_csrs_mem),
		.sbaddress_o(sbaddress_csrs_sba),
		.sbaddress_i(sbaddress_sba_csrs),
		.sbaddress_write_valid_o(sbaddress_write_valid),
		.sbreadonaddr_o(sbreadonaddr),
		.sbautoincrement_o(sbautoincrement),
		.sbaccess_o(sbaccess),
		.sbreadondata_o(sbreadondata),
		.sbdata_o(sbdata_write),
		.sbdata_read_valid_o(sbdata_read_valid),
		.sbdata_write_valid_o(sbdata_write_valid),
		.sbdata_i(sbdata_read),
		.sbdata_valid_i(sbdata_valid),
		.sbbusy_i(sbbusy),
		.sberror_valid_i(sberror_valid),
		.sberror_i(sberror)
	);
	dm_sba #(.BusWidth(BusWidth)) i_dm_sba(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.master_req_o(host_req_o),
		.master_add_o(host_add_o),
		.master_we_o(host_we_o),
		.master_wdata_o(host_wdata_o),
		.master_be_o(host_be_o),
		.master_gnt_i(host_gnt_i),
		.master_r_valid_i(host_r_valid_i),
		.master_r_err_i(1'b0),
		.master_r_other_err_i(1'b0),
		.master_r_rdata_i(host_r_rdata_i),
		.dmactive_i(dmactive_o),
		.sbaddress_i(sbaddress_csrs_sba),
		.sbaddress_o(sbaddress_sba_csrs),
		.sbaddress_write_valid_i(sbaddress_write_valid),
		.sbreadonaddr_i(sbreadonaddr),
		.sbautoincrement_i(sbautoincrement),
		.sbaccess_i(sbaccess),
		.sbreadondata_i(sbreadondata),
		.sbdata_i(sbdata_write),
		.sbdata_read_valid_i(sbdata_read_valid),
		.sbdata_write_valid_i(sbdata_write_valid),
		.sbdata_o(sbdata_read),
		.sbdata_valid_o(sbdata_valid),
		.sbbusy_o(sbbusy),
		.sberror_valid_o(sberror_valid),
		.sberror_o(sberror)
	);
	dm_mem #(
		.NrHarts(NrHarts),
		.BusWidth(BusWidth),
		.SelectableHarts(SelectableHarts),
		.DmBaseAddress(1)
	) i_dm_mem(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.ndmreset_i(ndmreset),
		.debug_req_o(debug_req_o),
		.hartsel_i(hartsel),
		.haltreq_i(haltreq),
		.resumereq_i(resumereq),
		.clear_resumeack_i(clear_resumeack),
		.halted_o(halted),
		.resuming_o(resumeack),
		.cmd_valid_i(cmd_valid),
		.cmd_i(cmd),
		.cmderror_valid_o(cmderror_valid),
		.cmderror_o(cmderror),
		.cmdbusy_o(cmdbusy),
		.progbuf_i(progbuf),
		.data_i(data_csrs_mem),
		.data_o(data_mem_csrs),
		.data_valid_o(data_valid),
		.req_i(device_req_i),
		.we_i(device_we_i),
		.addr_i(device_addr_i),
		.wdata_i(device_wdata_i),
		.be_i(device_be_i),
		.rdata_o(device_rdata_o)
	);
	dmi_jtag #(.IdcodeValue(IdcodeValue)) dap(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.testmode_i(testmode_i),
		.test_rst_ni(1'b1),
		.dmi_rst_no(dmi_rst_n),
		.dmi_req_o(dmi_req),
		.dmi_req_valid_o(dmi_req_valid),
		.dmi_req_ready_i(dmi_req_ready),
		.dmi_resp_i(dmi_rsp),
		.dmi_resp_ready_o(dmi_rsp_ready),
		.dmi_resp_valid_i(dmi_rsp_valid),
		.tck_i(tck_i),
		.tms_i(tms_i),
		.trst_ni(trst_ni),
		.td_i(td_i),
		.td_o(td_o),
		.tdo_oe_o()
	);
endmodule
