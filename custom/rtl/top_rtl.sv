module top_rtl #(
  parameter SRAMInitFile = ""
) (
   input 	clk,
   input 	rst_n,
   input [7:0] 	gpio_in,
   output [7:0] gpio_out
);

  custom_ibex #(
    .GpiWidth     ( 8            ),
    .GpoWidth     ( 8            ),
    .PwmWidth     ( 12           ),
    .SRAMInitFile ( SRAMInitFile )
  ) u_ibex_demo_system (
    //input
    .clk_sys_i (clk),
    .rst_sys_ni(rst_n),
    .gp_i      (gpio_in),
    .uart_rx_i (1'b1),

    //output
    .gp_o     (gpio_out),
    .pwm_o    (),
    .uart_tx_o(),

    .spi_rx_i (1'b0),
    .spi_tx_o (),
    .spi_sck_o(),

    .trst_ni(1'b1),
    .tms_i  (1'b0),
    .tck_i  (1'b0),
    .td_i   (1'b0),
    .td_o   ()
  );

endmodule
