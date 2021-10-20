
module led(
	input clk,
	input reset,
	output  [9:0]LEDR
);

reg [31:0]count_w,count_r;
reg [9:0]LED_w,LED_r;
assign LEDR = LED_r;
always@(*)begin
	if(count_r == 10000000)begin
		count_w = 0;
		LED_w = LED_r + 1;
	end
	else begin
		LED_w = LED_r;
		count_w = count_r+1;
	end
end

always @(posedge clk or negedge reset) begin
	if(!reset)begin
		count_r <= 0;
		LED_r <= 0;
	end
	else begin
		count_r <= count_w;
		LED_r <= LED_w;
	end
end



endmodule