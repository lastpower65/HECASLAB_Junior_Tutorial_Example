module LFSR (
    input i_clk,
    input i_lfsr_enable,
    input [NUM_BITS - 1 : 0] i_seed,
    output [NUM_BITS - 1 : 0]o_lfsr_data
);

//parameter
parameter NUM_BITS = 25;

parameter IDLE = 0;

//reg and wire
reg [NUM_BITS:0]o_lfsr_data_w,o_lfsr_data_r;
wire r_XNOR;
assign o_lfsr_data = o_lfsr_data_r;
assign r_XNOR = o_lfsr_data_r[25]^~o_lfsr_data_r[22];
always @(*) begin
    o_lfsr_data_w = {o_lfsr_data_r[NUM_BITS-2:0], r_XNOR};
end

always @(posedge i_clk)begin
    if (i_lfsr_enable == 1'b1)
    begin
        o_lfsr_data_r <= i_seed;
    end
    else begin
        o_lfsr_data_r <= o_lfsr_data_w;
    end
end

endmodule