module Binary_to_Decimal (
    input [7:0] eight_bit_value,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds
);
    integer  i;
    always @(*) begin
		  hundreds = 4'b0;
		  tens = 4'b0;
		  ones = 4'b0;
        for(i = 7;i >=0;i = i - 1)begin
            if(hundreds >= 5)begin
                hundreds = hundreds + 3;
            end
            if(tens >= 5)begin
                tens = tens + 3;
            end
            if(ones >= 5)begin
                ones = ones +3;
            end
       

			  hundreds = hundreds << 1;
			  hundreds[0] = tens[3];
			  tens = tens << 1;
			  tens[0] = ones[3];
			  ones = ones << 1;
			  ones[0] = eight_bit_value[i]; 
		  end
    end

endmodule