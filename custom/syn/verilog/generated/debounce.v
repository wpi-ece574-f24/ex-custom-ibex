module debounce (
	clk_i,
	rst_ni,
	btn_i,
	btn_o
);
	parameter [31:0] ClkCount = 500;
	input wire clk_i;
	input wire rst_ni;
	input wire btn_i;
	output wire btn_o;
	wire [$clog2(ClkCount + 1) - 1:0] cnt_d;
	reg [$clog2(ClkCount + 1) - 1:0] cnt_q;
	wire btn_d;
	reg btn_q;
	assign btn_o = btn_q;
	always @(posedge clk_i or negedge rst_ni) begin : p_fsm_reg
		if (!rst_ni) begin
			cnt_q <= 1'sb0;
			btn_q <= 1'sb0;
		end
		else begin
			cnt_q <= cnt_d;
			btn_q <= btn_d;
		end
	end
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	assign btn_d = (sv2v_cast_32(cnt_q) >= ClkCount ? btn_i : btn_q);
	assign cnt_d = ((btn_i == btn_q) || (sv2v_cast_32(cnt_q) >= ClkCount) ? {$clog2(ClkCount + 1) {1'sb0}} : cnt_q + 1);
endmodule
