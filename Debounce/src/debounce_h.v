// 通过低电平持续的周期数来判定其是否为高电平毛刺
// 本设计目标是过滤持续时间不超过3个cycle的高电平毛刺
module debounce_h 
(
    input           clk,
    input           rst_n,
    input           in,
    
    output  reg     out
);
    
    wire            cnt_rst_n; // 低电平持续时间计数器的使能信号        

    reg     [1:0]   cnt; // 低电平计数器
    reg             out_rst;        

// 正常工作模式下，只有复位信号为1且输入信号为高电平时cnt_rst_n才为1
assign cnt_rst_n = rst_n & in;

always @(posedge clk or negedge rst_n) begin
    if(!cnt_rst_n)
        cnt <= 2'b00;
    else
        cnt <= cnt + 2'b1; // 在in为1时计数
end

always @(posedge clk or negedge rst_n) begin
    if(!cnt_rst_n)
        out_rst <= 1'b0;
    else if(cnt == 2'b11)// 当高电平持续时间超过3个cycle则认定此低电平有效
        out_rst <= 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!cnt_rst_n)
        out <= 1'b0;
    else
        out <= out_rst;
end

endmodule