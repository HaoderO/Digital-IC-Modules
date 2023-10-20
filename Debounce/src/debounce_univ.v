// 通过低电平持续的周期数来判定其是否为高（低）电平毛刺
// 本设计目标是过滤持续时间不超过3个cycle的高（低）电平毛刺
module debounce_univ 
(
    input           clk,
    input           rst_n,
    input           in,
    
    output  reg     out
);
    
    reg     [3:0]   in_deb; // 低电平计数器

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        in_deb <= 4'b1111;
    else
        in_deb <= {in_deb[2:0],in};
end
// 高3位按位相或滤除低电平毛刺，按位相与滤除高电平毛刺



// 按位相或：只有连续的三个（周期）的低电平才会输出0
// 按位相与：只有连续的三个（周期）的高电平才会输出1
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out <= 1'b1;
    else
        out <= out ? (|in_deb[3:1]) : (&in_deb[3:1]);
end

endmodule