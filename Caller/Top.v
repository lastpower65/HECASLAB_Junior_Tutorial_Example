module Top (
	input        i_clk,
	input        i_rst_n,
	input        i_start,
	output [7:0] o_random_out,
	output [2:0] state
);

//parameter
parameter IDLE = 0;
parameter COUNT_NEGATIVE_TIME = 1;
parameter LFSR_ACTIVATE = 2;
parameter FIRST_SPEED = 3;
parameter SECOND_SPEED = 4;
parameter THIRD_SPEED = 5;
parameter STOP = 6;
parameter NUM_BITS = 25;
//submodule 
LFSR L1(
    .i_clk(i_clk),
    .i_lfsr_enable(lfsr_enable),
    .i_seed(negative_time_r),
    .o_lfsr_data(lfsr_data)
);

//reg and wire
reg [2:0]state_w,state_r;
//reg [3:0]hundreds_w,hundreds_w;

reg [7:0]random_out_w,random_out_r;
reg [25:0]speed_counter_w,speed_counter_r;
reg [2:0] output_number_w,output_number_r;
reg [25:0] negative_time_w,negative_time_r;
reg lfsr_enable_w,lfsr_enable_r;

wire lfsr_enable;
wire [NUM_BITS - 1 : 0]lfsr_data;
//continuous assign
assign state = state_r;
assign o_random_out = random_out_r;
assign lfsr_enable = lfsr_enable_r;

always @(*) begin
    state_w = state_r;
    random_out_w  = random_out_r;
    speed_counter_w = speed_counter_r;
    output_number_w = output_number_r;
    negative_time_w = negative_time_r;
    lfsr_enable_w = lfsr_enable_r ;
    case (state_r)
        IDLE:begin
            if(!i_start)begin
                state_w = COUNT_NEGATIVE_TIME;
                negative_time_w = 0;
            end
            else begin
                state_w = state_r;
                random_out_w  = 5;
                speed_counter_w = 0;
                output_number_w = 0;
            end
        end 
        COUNT_NEGATIVE_TIME:begin
            if(!i_start)begin
                
                negative_time_w = negative_time_r + 1;
                state_w = state_r;
            end
            else begin
                lfsr_enable_w = 1;
                state_w = LFSR_ACTIVATE;
                negative_time_w = negative_time_r;
            end
        end
        LFSR_ACTIVATE:begin
            lfsr_enable_w = 0;
            state_w = FIRST_SPEED;
        end
        FIRST_SPEED:begin
            if(output_number_r == 5)begin
                state_w = SECOND_SPEED;
                speed_counter_w = 0;
                output_number_w = 0;
                random_out_w = 5;
            end
            else begin
                if(speed_counter_r == 20000000)begin
                    speed_counter_w = 0;
                    output_number_w = output_number_r + 1;
                    random_out_w = lfsr_data[7:0];
                end
                else begin
                    speed_counter_w = speed_counter_r + 1;
                    output_number_w = output_number_r ;
                end
            end
        end
        SECOND_SPEED:begin
            if(output_number_r == 5)begin
                state_w = THIRD_SPEED;
                speed_counter_w = 0;
                output_number_w = 0;
                random_out_w = 5;
            end
            else begin
                if(speed_counter_r == 10000000)begin
                    speed_counter_w = 0;
                    output_number_w = output_number_r + 1;
                    random_out_w = lfsr_data[7:0];
                end
                else begin
                    speed_counter_w = speed_counter_r + 1;
                    output_number_w = output_number_r ;
                end
            end
        end
        THIRD_SPEED:begin
            if(output_number_r == 5)begin
                state_w = STOP;
                speed_counter_w = 0;
                output_number_w = 0;
                random_out_w = 5;
            end
            else begin
                if(speed_counter_r == 5000000)begin
                    speed_counter_w = 0;
                    output_number_w = output_number_r + 1;
                    random_out_w = lfsr_data[7:0];
                end
                else begin
                    speed_counter_w = speed_counter_r + 1;
                    output_number_w = output_number_r;
                end
            end

        end
        STOP:begin
            output_number_w = output_number_r;
			random_out_w = random_out_r;
        end
        default:begin
            state_w = IDLE;
        end 
    endcase
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        state_r <= IDLE;
        random_out_r <= 0;
        speed_counter_r <= 0;
        output_number_r <= 0;
        negative_time_r <= 0;
        lfsr_enable_r <= 0;
    end
    else begin
        state_r <= state_w;
        random_out_r <= random_out_w;
        speed_counter_r <= speed_counter_w;
        output_number_r <= output_number_w;
        negative_time_r <= negative_time_w;
        lfsr_enable_r <= lfsr_enable_w;

    end
end
endmodule
