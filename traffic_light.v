module traffic_light_4way (
    input  wire clk,
    input  wire rst_n,         
    output reg  ns_red,
    output reg  ns_yellow,
    output reg  ns_green,
    output reg  ew_red,
    output reg  ew_yellow,
    output reg  ew_green
);

    parameter S_NS_GREEN  = 2'b00, S_NS_YELLOW = 2'b01,  S_EW_GREEN  = 2'b10, S_EW_YELLOW = 2'b11;
    
    parameter GREEN_TIME  = 4'd10,  YELLOW_TIME = 4'd3;  

    reg [1:0] state, next_state;
    reg [3:0] timer;

   
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_NS_GREEN;
            timer <= 4'd0;
        end 
	else begin
            if (timer == 4'd0) begin
                state <= next_state;
                case (next_state)
                    S_NS_GREEN  : timer <= GREEN_TIME  - 1;
                    S_NS_YELLOW : timer <= YELLOW_TIME - 1;
                    S_EW_GREEN  : timer <= GREEN_TIME  - 1;
                    S_EW_YELLOW : timer <= YELLOW_TIME - 1;
                    default     : timer <= GREEN_TIME  - 1;
                endcase
            end 
	else begin
                timer <= timer - 1;
            end
        end
    end
    always @(*) begin
        case (state)
            S_NS_GREEN  : next_state = S_NS_YELLOW;
            S_NS_YELLOW : next_state = S_EW_GREEN;
            S_EW_GREEN  : next_state = S_EW_YELLOW;
            S_EW_YELLOW : next_state = S_NS_GREEN;
            default     : next_state = S_NS_GREEN;
        endcase
    end
    always @(*) begin
        {ns_red, ns_yellow, ns_green} = 3'b100;
        {ew_red, ew_yellow, ew_green} = 3'b100;

        case (state)
            S_NS_GREEN : begin
                {ns_red, ns_yellow, ns_green} = 3'b001; 
                {ew_red, ew_yellow, ew_green} = 3'b100;  
            end
            S_NS_YELLOW: begin
                {ns_red, ns_yellow, ns_green} = 3'b010; 
                {ew_red, ew_yellow, ew_green} = 3'b100;  
            end
            S_EW_GREEN : begin
                {ns_red, ns_yellow, ns_green} = 3'b100;  
                {ew_red, ew_yellow, ew_green} = 3'b001;  
            end
            S_EW_YELLOW: begin
                {ns_red, ns_yellow, ns_green} = 3'b100;  
                {ew_red, ew_yellow, ew_green} = 3'b010;  
            end
        endcase
    end

endmodule
