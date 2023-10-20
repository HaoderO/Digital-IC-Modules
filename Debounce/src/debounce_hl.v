// 通过低电平持续的周期数来判定其是否为高（低）电平毛刺
// 本设计目标是过滤持续时间不超过3个cycle的高（低）电平毛刺
module debounce_hl 
(
    input           clk,
    input           rst_n,
    input           in,
    
    output  reg     out
);
    
    wire            cnt1_rst_n; // 高电平持续时间计数器的使能信号        
    wire            cnt2_rst_n; // 低电平持续时间计数器的使能信号        

    reg     [1:0]   cnt1; // 高电平计数器
    reg     [1:0]   cnt2; // 低电平计数器
    reg             out_set;        
    reg             out_rst;        

// 高电平计数使能
assign cnt1_rst_n = rst_n & in;
// 低电平计数使能
assign cnt2_rst_n = rst_n & (~in);
// 电平计数
always @(posedge clk or negedge rst_n) begin
    if(!cnt1_rst_n)
        cnt1 <= 2'b00;
    else
        cnt1 <= cnt1 + 2'b1; // 在in为1时计数
end

always @(posedge clk or negedge rst_n) begin
    if(!cnt2_rst_n)
        cnt2 <= 2'b00;
    else
        cnt2 <= cnt2 + 2'b1; // 在in为0时计数
end
// 电平有效判定
always @(posedge clk or negedge rst_n) begin
    if(!cnt1_rst_n)
        out_set <= 1'b0;
    else if(cnt1 == 2'b11)// 当高电平持续时间超过3个cycle则认定此低电平有效
        out_set <= 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!cnt2_rst_n)
        out_rst <= 1'b0;
    else if(cnt2 == 2'b11)// 当低电平持续时间超过3个cycle则认定此低电平有效
        out_rst <= 1'b1;
end
// 过滤后的电平输出
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out <= 1'b1;
    else if(out_set)
        out <= 1'b1;
    else if(out_rst)
        out <= 1'b0;
end

endmodule