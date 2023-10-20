module debounce_l 
(
    input               rst_n       ,
    input               clk         ,
    input               start       ,
    input       [7:0]   a           ,
    input       [7:0]   b           ,

    output  reg         done        ,
    output  reg [7:0]   quotient    ,        
    output  reg [7:0]   remainder   
);  

    reg         [7:0]   a_temp      ;
    reg         [7:0]   b_temp      ;
    reg                 symbol      ;
    reg         [2:0]   k           ;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        quotient  <= 8'b0;
        remainder <= 8'b0;
        k         <= 3'b0;
        symbol    <= 1'b0;
        done      <= 1'b0;        
    end
    else if(start) begin
        case (k)
            0 : begin
                symbol <= a[7]^b[7];
                a_temp <= a[7] ? (~a + 8'b1) : a;
                b_temp <= b[7] ? (~b + 8'b1) : b;
                k      <= k + 3'b1;
            end 
            1 : begin
                if (a_temp < b_temp) begin
                    remainder <= a_temp;
                    quotient  <= symbol ? (~quotient + 8'b1) : quotient;
                    k         <= k + 3'b1;
                end
                else begin
                    a_temp   <= a_temp + (~b_temp + 8'b1);
                    quotient <= quotient + 8'b1;                    
                end
            end
            2 : begin
                done <= 1'b1;
                k    <= k + 3'b1;
            end
            3 : begin
                done <= 1'b0;
                k    <= 3'b0;
            end
            default : begin
                quotient  <= quotient;
                remainder <= remainder;
                k         <= 3'b0;
                symbol    <= symbol;
                done      <= done;                
            end 
        endcase
    end
end

endmodule