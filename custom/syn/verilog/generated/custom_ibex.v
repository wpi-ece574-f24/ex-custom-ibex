module custom_ibex (
	clk_sys_i,
	rst_sys_ni,
	gp_i,
	gp_o,
	pwm_o,
	uart_rx_i,
	uart_tx_o,
	spi_rx_i,
	spi_tx_o,
	spi_sck_o,
	tck_i,
	tms_i,
	trst_ni,
	td_i,
	td_o
);
	parameter signed [31:0] GpiWidth = 8;
	parameter signed [31:0] GpoWidth = 16;
	parameter signed [31:0] PwmWidth = 12;
	parameter [31:0] ClockFrequency = 50000000;
	parameter [31:0] BaudRate = 115200;
	parameter integer RegFile = 32'sd1;
	parameter SRAMInitFile = "";
	input wire clk_sys_i;
	input wire rst_sys_ni;
	input wire [GpiWidth - 1:0] gp_i;
	output wire [GpoWidth - 1:0] gp_o;
	output wire [PwmWidth - 1:0] pwm_o;
	input wire uart_rx_i;
	output wire uart_tx_o;
	input wire spi_rx_i;
	output wire spi_tx_o;
	output wire spi_sck_o;
	input wire tck_i;
	input wire tms_i;
	input wire trst_ni;
	input wire td_i;
	output wire td_o;
	localparam [31:0] MEM_SIZE = 65536;
	localparam [31:0] MEM_START = 32'h00100000;
	localparam [31:0] MEM_MASK = ~65535;
	localparam [31:0] GPIO_SIZE = 4096;
	localparam [31:0] GPIO_START = 32'h80000000;
	localparam [31:0] GPIO_MASK = ~4095;
	localparam [31:0] DEBUG_SIZE = 65536;
	localparam [31:0] DEBUG_START = 32'h1a110000;
	localparam [31:0] DEBUG_MASK = ~65535;
	localparam [31:0] UART_SIZE = 4096;
	localparam [31:0] UART_START = 32'h80001000;
	localparam [31:0] UART_MASK = ~4095;
	localparam [31:0] TIMER_SIZE = 4096;
	localparam [31:0] TIMER_START = 32'h80002000;
	localparam [31:0] TIMER_MASK = ~4095;
	localparam [31:0] PWM_SIZE = 4096;
	localparam [31:0] PWM_START = 32'h80003000;
	localparam [31:0] PWM_MASK = ~4095;
	localparam signed [31:0] PwmCtrSize = 8;
	parameter [31:0] SPI_SIZE = 1024;
	parameter [31:0] SPI_START = 32'h80004000;
	parameter [31:0] SPI_MASK = ~(SPI_SIZE - 1);
	parameter [31:0] MYREG_SIZE = 1024;
	parameter [31:0] MYREG_START = 32'h80005000;
	parameter [31:0] MYREG_MASK = ~(MYREG_SIZE - 1);
	parameter [31:0] SIM_CTRL_SIZE = 1024;
	parameter [31:0] SIM_CTRL_START = 32'h00020000;
	parameter [31:0] SIM_CTRL_MASK = ~(SIM_CTRL_SIZE - 1);
	localparam [0:0] DBG = 1;
	localparam [31:0] DbgHwBreakNum = 2;
	localparam [0:0] DbgTriggerEn = 1'b1;
	localparam signed [31:0] NrDevices = (DBG ? 9 : 8);
	localparam signed [31:0] NrHosts = (DBG ? 2 : 1);
	wire timer_irq;
	wire uart_irq;
	wire [0:NrHosts - 1] host_req;
	wire [0:NrHosts - 1] host_gnt;
	wire [(NrHosts * 32) - 1:0] host_addr;
	wire [0:NrHosts - 1] host_we;
	wire [(NrHosts * 4) - 1:0] host_be;
	wire [(NrHosts * 32) - 1:0] host_wdata;
	wire [0:NrHosts - 1] host_rvalid;
	wire [(NrHosts * 32) - 1:0] host_rdata;
	wire [0:NrHosts - 1] host_err;
	wire [0:NrDevices - 1] device_req;
	wire [(NrDevices * 32) - 1:0] device_addr;
	wire [0:NrDevices - 1] device_we;
	wire [(NrDevices * 4) - 1:0] device_be;
	wire [(NrDevices * 32) - 1:0] device_wdata;
	wire [0:NrDevices - 1] device_rvalid;
	wire [(NrDevices * 32) - 1:0] device_rdata;
	wire [0:NrDevices - 1] device_err;
	wire core_instr_req;
	wire core_instr_gnt;
	reg core_instr_rvalid;
	wire [31:0] core_instr_addr;
	wire [31:0] core_instr_rdata;
	reg core_instr_sel_dbg;
	wire mem_instr_req;
	wire [31:0] mem_instr_rdata;
	wire dbg_instr_req;
	wire dbg_device_req;
	wire [31:0] dbg_device_addr;
	wire dbg_device_we;
	wire [3:0] dbg_device_be;
	wire [31:0] dbg_device_wdata;
	reg dbg_device_rvalid;
	wire [31:0] dbg_device_rdata;
	wire rst_core_n;
	wire ndmreset_req;
	wire dm_debug_req;
	wire [(NrDevices * 32) - 1:0] cfg_device_addr_base;
	wire [(NrDevices * 32) - 1:0] cfg_device_addr_mask;
	assign cfg_device_addr_base[(NrDevices - 1) * 32+:32] = MEM_START;
	assign cfg_device_addr_mask[(NrDevices - 1) * 32+:32] = MEM_MASK;
	assign cfg_device_addr_base[(NrDevices - 2) * 32+:32] = GPIO_START;
	assign cfg_device_addr_mask[(NrDevices - 2) * 32+:32] = GPIO_MASK;
	assign cfg_device_addr_base[(NrDevices - 3) * 32+:32] = PWM_START;
	assign cfg_device_addr_mask[(NrDevices - 3) * 32+:32] = PWM_MASK;
	assign cfg_device_addr_base[(NrDevices - 4) * 32+:32] = UART_START;
	assign cfg_device_addr_mask[(NrDevices - 4) * 32+:32] = UART_MASK;
	assign cfg_device_addr_base[(NrDevices - 5) * 32+:32] = TIMER_START;
	assign cfg_device_addr_mask[(NrDevices - 5) * 32+:32] = TIMER_MASK;
	assign cfg_device_addr_base[(NrDevices - 6) * 32+:32] = SPI_START;
	assign cfg_device_addr_mask[(NrDevices - 6) * 32+:32] = SPI_MASK;
	assign cfg_device_addr_base[(NrDevices - 8) * 32+:32] = SIM_CTRL_START;
	assign cfg_device_addr_mask[(NrDevices - 8) * 32+:32] = SIM_CTRL_MASK;
	assign cfg_device_addr_base[(NrDevices - 7) * 32+:32] = MYREG_START;
	assign cfg_device_addr_mask[(NrDevices - 7) * 32+:32] = MYREG_MASK;
	generate
		if (DBG) begin : g_dbg_device_cfg
			assign cfg_device_addr_base[(NrDevices - 9) * 32+:32] = DEBUG_START;
			assign cfg_device_addr_mask[(NrDevices - 9) * 32+:32] = DEBUG_MASK;
			assign device_err[32'sd8] = 1'b0;
		end
	endgenerate
	assign device_err[32'sd0] = 1'b0;
	assign device_err[32'sd1] = 1'b0;
	assign device_err[32'sd2] = 1'b0;
	assign device_err[32'sd3] = 1'b0;
	assign device_err[32'sd5] = 1'b0;
	assign device_err[32'sd6] = 1'b0;
	assign device_err[32'sd7] = 1'b0;
	bus #(
		.NrDevices(NrDevices),
		.NrHosts(NrHosts),
		.DataWidth(32),
		.AddressWidth(32)
	) u_bus(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.host_req_i(host_req),
		.host_gnt_o(host_gnt),
		.host_addr_i(host_addr),
		.host_we_i(host_we),
		.host_be_i(host_be),
		.host_wdata_i(host_wdata),
		.host_rvalid_o(host_rvalid),
		.host_rdata_o(host_rdata),
		.host_err_o(host_err),
		.device_req_o(device_req),
		.device_addr_o(device_addr),
		.device_we_o(device_we),
		.device_be_o(device_be),
		.device_wdata_o(device_wdata),
		.device_rvalid_i(device_rvalid),
		.device_rdata_i(device_rdata),
		.device_err_i(device_err),
		.cfg_device_addr_base(cfg_device_addr_base),
		.cfg_device_addr_mask(cfg_device_addr_mask)
	);
	assign mem_instr_req = core_instr_req & ((core_instr_addr & cfg_device_addr_mask[(NrDevices - 1) * 32+:32]) == cfg_device_addr_base[(NrDevices - 1) * 32+:32]);
	assign dbg_instr_req = core_instr_req & ((core_instr_addr & cfg_device_addr_mask[(NrDevices - 9) * 32+:32]) == cfg_device_addr_base[(NrDevices - 9) * 32+:32]);
	assign core_instr_gnt = mem_instr_req | (dbg_instr_req & ~device_req[32'sd8]);
	always @(posedge clk_sys_i or negedge rst_sys_ni)
		if (!rst_sys_ni) begin
			core_instr_rvalid <= 1'b0;
			core_instr_sel_dbg <= 1'b0;
		end
		else begin
			core_instr_rvalid <= core_instr_gnt;
			core_instr_sel_dbg <= dbg_instr_req;
		end
	assign core_instr_rdata = (core_instr_sel_dbg ? dbg_device_rdata : mem_instr_rdata);
	assign rst_core_n = rst_sys_ni & ~ndmreset_req;
	localparam [63:0] dm_HaltAddress = 64'h0000000000000800;
	localparam [63:0] dm_ExceptionAddress = 2064;
	ibex_top #(
		.RegFile(RegFile),
		.MHPMCounterNum(10),
		.RV32M(32'sd2),
		.RV32B(32'sd0),
		.DbgTriggerEn(DbgTriggerEn),
		.DbgHwBreakNum(DbgHwBreakNum),
		.DmHaltAddr(DEBUG_START + dm_HaltAddress[31:0]),
		.DmExceptionAddr(DEBUG_START + dm_ExceptionAddress[31:0])
	) u_top(
		.clk_i(clk_sys_i),
		.rst_ni(rst_core_n),
		.test_en_i('b0),
		.scan_rst_ni(1'b1),
		.ram_cfg_i('b0),
		.hart_id_i(32'b00000000000000000000000000000000),
		.boot_addr_i(32'h00100000),
		.instr_req_o(core_instr_req),
		.instr_gnt_i(core_instr_gnt),
		.instr_rvalid_i(core_instr_rvalid),
		.instr_addr_o(core_instr_addr),
		.instr_rdata_i(core_instr_rdata),
		.instr_rdata_intg_i(1'sb0),
		.instr_err_i(1'sb0),
		.data_req_o(host_req[32'sd0]),
		.data_gnt_i(host_gnt[32'sd0]),
		.data_rvalid_i(host_rvalid[32'sd0]),
		.data_we_o(host_we[32'sd0]),
		.data_be_o(host_be[(NrHosts - 1) * 4+:4]),
		.data_addr_o(host_addr[(NrHosts - 1) * 32+:32]),
		.data_wdata_o(host_wdata[(NrHosts - 1) * 32+:32]),
		.data_wdata_intg_o(),
		.data_rdata_i(host_rdata[(NrHosts - 1) * 32+:32]),
		.data_rdata_intg_i(1'sb0),
		.data_err_i(host_err[32'sd0]),
		.irq_software_i(1'b0),
		.irq_timer_i(timer_irq),
		.irq_external_i(1'b0),
		.irq_fast_i({14'b00000000000000, uart_irq}),
		.irq_nm_i(1'b0),
		.scramble_key_valid_i(1'sb0),
		.scramble_key_i(1'sb0),
		.scramble_nonce_i(1'sb0),
		.scramble_req_o(),
		.debug_req_i(dm_debug_req),
		.crash_dump_o(),
		.double_fault_seen_o(),
		.fetch_enable_i(1'sb1),
		.alert_minor_o(),
		.alert_major_internal_o(),
		.alert_major_bus_o(),
		.core_sleep_o()
	);
	ram_2p #(
		.Depth(16384),
		.MemInitFile(SRAMInitFile)
	) u_ram(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.a_req_i(device_req[32'sd0]),
		.a_we_i(device_we[32'sd0]),
		.a_be_i(device_be[(NrDevices - 1) * 4+:4]),
		.a_addr_i(device_addr[(NrDevices - 1) * 32+:32]),
		.a_wdata_i(device_wdata[(NrDevices - 1) * 32+:32]),
		.a_rvalid_o(device_rvalid[32'sd0]),
		.a_rdata_o(device_rdata[(NrDevices - 1) * 32+:32]),
		.b_req_i(mem_instr_req),
		.b_we_i(1'b0),
		.b_be_i(4'b0000),
		.b_addr_i(core_instr_addr),
		.b_wdata_i(32'b00000000000000000000000000000000),
		.b_rvalid_o(),
		.b_rdata_o(mem_instr_rdata)
	);
	gpio #(
		.GpiWidth(GpiWidth),
		.GpoWidth(GpoWidth)
	) u_gpio(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.device_req_i(device_req[32'sd1]),
		.device_addr_i(device_addr[(NrDevices - 2) * 32+:32]),
		.device_we_i(device_we[32'sd1]),
		.device_be_i(device_be[(NrDevices - 2) * 4+:4]),
		.device_wdata_i(device_wdata[(NrDevices - 2) * 32+:32]),
		.device_rvalid_o(device_rvalid[32'sd1]),
		.device_rdata_o(device_rdata[(NrDevices - 2) * 32+:32]),
		.gp_i(gp_i),
		.gp_o(gp_o)
	);
	pwm_wrapper #(
		.PwmWidth(PwmWidth),
		.PwmCtrSize(PwmCtrSize),
		.BusAddrWidth(32)
	) u_pwm(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.device_req_i(device_req[32'sd2]),
		.device_addr_i(device_addr[(NrDevices - 3) * 32+:32]),
		.device_we_i(device_we[32'sd2]),
		.device_be_i(device_be[(NrDevices - 3) * 4+:4]),
		.device_wdata_i(device_wdata[(NrDevices - 3) * 32+:32]),
		.device_rvalid_o(device_rvalid[32'sd2]),
		.device_rdata_o(device_rdata[(NrDevices - 3) * 32+:32]),
		.pwm_o(pwm_o)
	);
	uart #(
		.ClockFrequency(ClockFrequency),
		.BaudRate(BaudRate)
	) u_uart(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.device_req_i(device_req[32'sd3]),
		.device_addr_i(device_addr[(NrDevices - 4) * 32+:32]),
		.device_we_i(device_we[32'sd3]),
		.device_be_i(device_be[(NrDevices - 4) * 4+:4]),
		.device_wdata_i(device_wdata[(NrDevices - 4) * 32+:32]),
		.device_rvalid_o(device_rvalid[32'sd3]),
		.device_rdata_o(device_rdata[(NrDevices - 4) * 32+:32]),
		.uart_rx_i(uart_rx_i),
		.uart_irq_o(uart_irq),
		.uart_tx_o(uart_tx_o)
	);
	spi_top #(
		.ClockFrequency(ClockFrequency),
		.CPOL(0),
		.CPHA(1)
	) u_spi(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.device_req_i(device_req[32'sd5]),
		.device_addr_i(device_addr[(NrDevices - 6) * 32+:32]),
		.device_we_i(device_we[32'sd5]),
		.device_be_i(device_be[(NrDevices - 6) * 4+:4]),
		.device_wdata_i(device_wdata[(NrDevices - 6) * 32+:32]),
		.device_rvalid_o(device_rvalid[32'sd5]),
		.device_rdata_o(device_rdata[(NrDevices - 6) * 32+:32]),
		.spi_rx_i(spi_rx_i),
		.spi_tx_o(spi_tx_o),
		.sck_o(spi_sck_o),
		.byte_data_o()
	);
	myreg u_myreg(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.device_req_i(device_req[32'sd6]),
		.device_addr_i(device_addr[(NrDevices - 7) * 32+:32]),
		.device_we_i(device_we[32'sd6]),
		.device_be_i(device_be[(NrDevices - 7) * 4+:4]),
		.device_wdata_i(device_wdata[(NrDevices - 7) * 32+:32]),
		.device_rvalid_o(device_rvalid[32'sd6]),
		.device_rdata_o(device_rdata[(NrDevices - 7) * 32+:32])
	);
	timer #(
		.DataWidth(32),
		.AddressWidth(32)
	) u_timer(
		.clk_i(clk_sys_i),
		.rst_ni(rst_sys_ni),
		.timer_req_i(device_req[32'sd4]),
		.timer_we_i(device_we[32'sd4]),
		.timer_be_i(device_be[(NrDevices - 5) * 4+:4]),
		.timer_addr_i(device_addr[(NrDevices - 5) * 32+:32]),
		.timer_wdata_i(device_wdata[(NrDevices - 5) * 32+:32]),
		.timer_rvalid_o(device_rvalid[32'sd4]),
		.timer_rdata_o(device_rdata[(NrDevices - 5) * 32+:32]),
		.timer_err_o(device_err[32'sd4]),
		.timer_intr_o(timer_irq)
	);
	assign dbg_device_req = device_req[32'sd8] | dbg_instr_req;
	assign dbg_device_we = device_req[32'sd8] & device_we[32'sd8];
	assign dbg_device_addr = (device_req[32'sd8] ? device_addr[(NrDevices - 9) * 32+:32] : core_instr_addr);
	assign dbg_device_be = device_be[(NrDevices - 9) * 4+:4];
	assign dbg_device_wdata = device_wdata[(NrDevices - 9) * 32+:32];
	assign device_rvalid[32'sd8] = dbg_device_rvalid;
	assign device_rdata[(NrDevices - 9) * 32+:32] = dbg_device_rdata;
	always @(posedge clk_sys_i or negedge rst_sys_ni)
		if (!rst_sys_ni)
			dbg_device_rvalid <= 1'b0;
		else
			dbg_device_rvalid <= device_req[32'sd8];
	localparam [10:0] jtag_id_pkg_JEDEC_MANUFACTURER_ID = 11'h66f;
	localparam [3:0] jtag_id_pkg_JTAG_VERSION = 4'h1;
	localparam [31:0] jtag_id_pkg_RV_DM_JTAG_IDCODE = {jtag_id_pkg_JTAG_VERSION, 16'h1001, jtag_id_pkg_JEDEC_MANUFACTURER_ID, 1'b1};
	generate
		if (DBG) begin : gen_dm_top
			dm_top #(
				.NrHarts(1),
				.IdcodeValue(jtag_id_pkg_RV_DM_JTAG_IDCODE)
			) u_dm_top(
				.clk_i(clk_sys_i),
				.rst_ni(rst_sys_ni),
				.testmode_i(1'b0),
				.ndmreset_o(ndmreset_req),
				.dmactive_o(),
				.debug_req_o(dm_debug_req),
				.unavailable_i(1'b0),
				.device_req_i(dbg_device_req),
				.device_we_i(dbg_device_we),
				.device_addr_i(dbg_device_addr),
				.device_be_i(dbg_device_be),
				.device_wdata_i(dbg_device_wdata),
				.device_rdata_o(dbg_device_rdata),
				.host_req_o(host_req[32'sd1]),
				.host_add_o(host_addr[(NrHosts - 2) * 32+:32]),
				.host_we_o(host_we[32'sd1]),
				.host_wdata_o(host_wdata[(NrHosts - 2) * 32+:32]),
				.host_be_o(host_be[(NrHosts - 2) * 4+:4]),
				.host_gnt_i(host_gnt[32'sd1]),
				.host_r_valid_i(host_rvalid[32'sd1]),
				.host_r_rdata_i(host_rdata[(NrHosts - 2) * 32+:32]),
				.tck_i(tck_i),
				.tms_i(tms_i),
				.trst_ni(trst_ni),
				.td_i(td_i),
				.td_o(td_o)
			);
		end
		else begin : gen_no_dm
			assign dm_debug_req = 1'b0;
			assign ndmreset_req = 1'b0;
		end
	endgenerate
endmodule
