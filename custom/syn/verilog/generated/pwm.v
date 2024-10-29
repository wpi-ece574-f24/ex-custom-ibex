module pwm (
	clk_i,
	rst_ni,
	pulse_width_i,
	max_counter_i,
	modulated_o
);
	parameter signed [31:0] CtrSize = 8;
	input wire clk_i;
	input wire rst_ni;
	input wire [CtrSize - 1:0] pulse_width_i;
	input wire [CtrSize - 1:0] max_counter_i;
	output reg modulated_o;
	reg [CtrSize - 1:0] counter;
	always @(posedge clk_i or negedge rst_ni)
		if (!rst_ni) begin
			counter <= 'b0;
			modulated_o <= 'b0;
		end
		else if (max_counter_i == 0) begin
			counter <= 'b0;
			modulated_o <= 'b0;
		end
		else begin
			if (counter < max_counter_i)
				counter <= counter + 1;
			else
				counter <= 0;
			if (pulse_width_i > counter)
				modulated_o <= 1'b1;
			else
				modulated_o <= 1'b0;
		end
endmodule
