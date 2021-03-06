module seven_segment_display(
	input clk,
	input reset,
	output reg [7:0]HEX0
);

reg [31:0]count_r,count_w;
reg [3:0]output_value_r,output_value_w;
always @(*) begin
	if(count_r == 50000000)begin
		count_w = 0;
		if(output_value_r == 15)begin
			output_value_w = 0;
		end
		else begin
			output_value_w = output_value_r +1;
		end
		
	end
	else begin
		count_w = count_r + 1;
		output_value_w = output_value_r;
	end


	case (output_value_r)
		4'h0   : HEX0 = ~7'b011_1111;   //  numbering in comments at
		4'h1   : HEX0 = ~7'b000_0110;   //  top of this module.
		4'h2   : HEX0 = ~7'b101_1011;
		4'h3   : HEX0 = ~7'b100_1111;
		4'h4   : HEX0 = ~7'b110_0110;
		4'h5   : HEX0 = ~7'b110_1101;
		4'h6   : HEX0 = ~7'b111_1101;
		4'h7   : HEX0 = ~7'b000_0111;
		4'h8   : HEX0 = ~7'b111_1111;
		4'h9   : HEX0 = ~7'b110_1111;
		4'hA   : HEX0 = ~7'b111_0111;
		4'hB   : HEX0 = ~7'b111_1100;
		4'hC   : HEX0 = ~7'b011_1001;
		4'hD   : HEX0 = ~7'b101_1110;
		4'hE   : HEX0 = ~7'b111_1001;
		4'hF   : HEX0 = ~7'b111_0001;
		default: HEX0 = ~7'b100_0000; 
	endcase
end

always @(posedge clk or negedge reset) begin
	if(!reset)begin
		count_r <= 0;
		output_value_r<=0;
	end
	else begin
		output_value_r<=output_value_w;
		count_r <= count_w;
	end
end

endmodule