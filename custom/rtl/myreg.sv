module myreg #(
  parameter int unsigned AddrWidth = 32,
  parameter int unsigned RegAddr   = 8
) (
  input logic 		      clk_i,
  input logic 		      rst_ni,

  input logic 		      device_req_i,
  input logic [AddrWidth-1:0] device_addr_i,
  input logic 		      device_we_i,
  input logic [3:0] 	      device_be_i,
  input logic [31:0] 	      device_wdata_i,
  output logic 		      device_rvalid_o,
  output logic [31:0] 	      device_rdata_o
);

   localparam int 	       unsigned MYREG_REG1 = 32'h0;
   localparam int 	       unsigned MYREG_REG2 = 32'h4;
   
   logic [RegAddr-1:0] 	       reg_addr;
   logic 		       reg1_wr, reg1_rd;
   logic 		       reg2_wr, reg2_rd;

   logic [31:0] 	       reg1_data;
   logic [31:0] 	       reg2_data;
   
   // Decode write and read requests.
   assign reg_addr          = device_addr_i[RegAddr-1:0];
   assign reg1_wr           = device_req_i &  device_we_i & (reg_addr == MYREG_REG1[RegAddr-1:0]);
   assign reg1_rd           = device_req_i & ~device_we_i & (reg_addr == MYREG_REG1[RegAddr-1:0]);
   assign reg2_wr           = device_req_i &  device_we_i & (reg_addr == MYREG_REG2[RegAddr-1:0]);
   assign reg2_rd           = device_req_i & ~device_we_i & (reg_addr == MYREG_REG2[RegAddr-1:0]);
   
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
       reg1_data <= 32'b0;
       reg2_data <= 32'b0;
    end else begin
       if (reg1_wr)
	 begin
	    reg1_data[7:0]   <= {device_be_i[0] ? device_wdata_i[7:0] : reg1_data[7:0]};
	    reg1_data[15:8]  <= {device_be_i[1] ? device_wdata_i[15:8] : reg1_data[15:8]};
	    reg1_data[23:16] <= {device_be_i[2] ? device_wdata_i[23:16] : reg1_data[23:16]};
	    reg1_data[31:24] <= {device_be_i[3] ? device_wdata_i[31:24] : reg1_data[31:24]};	    
	 end
       if (reg2_wr)
	 begin
	    reg2_data[7:0]   <= {device_be_i[0] ? device_wdata_i[7:0] : reg2_data[7:0]};
	    reg2_data[15:8]  <= {device_be_i[1] ? device_wdata_i[15:8] : reg2_data[15:8]};
	    reg2_data[23:16] <= {device_be_i[2] ? device_wdata_i[23:16] : reg2_data[23:16]};
	    reg2_data[31:24] <= {device_be_i[3] ? device_wdata_i[31:24] : reg2_data[31:24]};	    
	 end
       device_rvalid_o <= device_req_i;
    end
  end

  // Assign device_rdata_o according to request type.
  always_comb begin
    if (reg1_rd)
      device_rdata_o = reg1_data;
    else if (reg2_rd)
      device_rdata_o = reg2_data;
    else
      device_rdata_o = 32'b0;
  end

  // Unused signals.
  logic [AddrWidth-1-RegAddr:0]  unused_device_addr;
  assign unused_device_addr  = device_addr_i[AddrWidth-1:RegAddr];
   
endmodule
