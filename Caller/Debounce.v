module Debounce (
	input  i_in,
	input  i_clk,
	input  i_rst_n,
	output o_debounced,
	output o_neg,
	output o_pos
);

parameter CNT_N = 7;
localparam CNT_BIT = $clog2(CNT_N+1);

reg o_debounced_r, o_debounced_w;
reg [CNT_BIT-1:0] counter_r, counter_w;
reg neg_r, neg_w, pos_r, pos_w;

assign o_debounced = o_debounced_r;
assign o_pos = pos_r;
assign o_neg = neg_r;

always@(*) begin
	if (i_in != o_debounced_r) begin
		counter_w = counter_r - 1;
	end else begin
		counter_w = CNT_N;
	end
	if (counter_r == 0) begin
		o_debounced_w = ~o_debounced_r;
	end else begin
		o_debounced_w = o_debounced_r;
	end
	pos_w = ~o_debounced_r &  o_debounced_w; // detect i_in posedge
	neg_w =  o_debounced_r & ~o_debounced_w; // detect i_in negedge
end

always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		o_debounced_r <= 1'b0;
		counter_r <= 1'b0;
		neg_r <= 1'b0;
		pos_r <= 1'b0;
	end else begin
		o_debounced_r <= o_debounced_w;
		counter_r <= counter_w;
		neg_r <= neg_w;
		pos_r <= pos_w;
	end
end

endmodule