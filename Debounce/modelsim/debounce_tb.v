module debounce_tb;

// Parameters
//Ports
reg     clk   = 0;
reg     rst_n = 0;
reg     in    = 0;
wire    out1;
wire    out2;
wire    out3;
wire    out4;

debounce_h  debounce_h_inst 
(
    .clk        (clk    ),
    .rst_n      (rst_n  ),
    .in         (in     ),

    .out        (out1   )
);

debounce_l  debounce_l_inst 
(
    .clk        (clk    ),
    .rst_n      (rst_n  ),
    .in         (in     ),
    
    .out        (out2   )
);

debounce_hl  debounce_hl_inst 
(
    .clk        (clk    ),
    .rst_n      (rst_n  ),
    .in         (in     ),
    
    .out        (out3   )
);

debounce_univ  debounce_univ_inst 
(
    .clk        (clk    ),
    .rst_n      (rst_n  ),
    .in         (in     ),
    
    .out        (out4   )
);

initial begin
    #100
    rst_n = 1;
    #1000
    $stop;
end

always #5  clk = ! clk ;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        in <= 1'b0;
    else
        in <= $random;
end

endmodule