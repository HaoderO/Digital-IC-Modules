
module adder_tb;

// Parameters
localparam  N = 8;
//Ports
reg           ci  ;
reg   [N-1:0] x   ;
reg   [N-1:0] y   ;
wire  [N-1:0] s   ;
wire          co  ;
reg           clk=1 ;     

adder 
#(
    .N  (N  )
)
adder_inst 
(
    .ci (ci ),
    .x  (x  ),
    .y  (y  ),
    .s  (s  ),
    .co (co )
);

always #10 clk <= ! clk;

always @(posedge clk) begin
    ci <= $random;
    x  <= $random;
    y  <= $random;
end

always @(posedge clk) begin
    $display("x = %b, y = %b, s = %b, co = %b", x, y, s, co);
end

initial begin
    #1000
    $stop;
end

endmodule