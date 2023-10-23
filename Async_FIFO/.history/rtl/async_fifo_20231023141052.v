// 地址位宽增加一位MSB用于判断空满
// 原因可参考Clifford E. Cummings, "Simulation and Synthesis Techniques for Asynchronous FIFO Design"
module async_fifo
#(
    parameter DEEPTH_BIT = 6,
    parameter DEEPTH     = 32,
    parameter WIDTH      = 32
)
(
    input  wire             wclk,
    input  wire             rclk,
    input  wire             wclr,
    input  wire             rclr,

    input  wire             rst_n,

    input  wire             wr_en,
    input  wire             rd_en,
    input  wire [WIDTH-1:0] dati,

    output wire             full,
    output wire             empty,
    output wire [WIDTH-1:0] dato,
    output wire [DEEPTH_BIT-1:0] wlevel,
    output wire [DEEPTH_BIT-1:0] rlevel
);

// internal signals
reg  [WIDTH-1:0]      ram[DEEPTH-1:0];
reg  [DEEPTH_BIT-1:0] wptr_wclk;
reg  [DEEPTH_BIT-1:0] rptr_rclk;
reg  [DEEPTH_BIT-1:0] wptr_sp1;
reg  [DEEPTH_BIT-1:0] wptr_sp2;
reg  [DEEPTH_BIT-1:0] rptr_sp1;
reg  [DEEPTH_BIT-1:0] rptr_sp2;
reg  [DEEPTH_BIT-1:0] wptr_gray;
reg  [DEEPTH_BIT-1:0] rptr_gray;
wire [DEEPTH_BIT-1:0] wptr_bin;
wire [DEEPTH_BIT-1:0] rptr_bin;
wire [DEEPTH_BIT-1:0] nxt_wptr_wclk;
wire [DEEPTH_BIT-1:0] nxt_rptr_rclk;
wire [DEEPTH_BIT-1:0] nxt_wptr_gray;
wire [DEEPTH_BIT-1:0] nxt_rptr_gray;

// 注意定义的深度为32，地址表示[4:0]，即[DEEPTH_BIT-2:0]
wire [DEEPTH_BIT-2:0] raddr;

// 写指针更新
assign nxt_wptr_wclk = (wr_en && !full) ? (wptr_wclk + 1'b1) : wptr_wclk;
// 写指针转格雷码
assign nxt_wptr_gray = (nxt_wptr_wclk >> 1) ^ nxt_wptr_wclk;
// 写指针跳转
always @(posedge wclk or negedge rst_n) 
begin
    if (rst_n == 1'b0) begin
        wptr_wclk <= {DEEPTH_BIT{1'b0}};
        wptr_gray <= {DEEPTH_BIT{1'b0}};
    end    
    else if (wclr) begin
        wptr_wclk <= {DEEPTH_BIT{1'b0}};
        wptr_gray <= {DEEPTH_BIT{1'b0}};    
    end
    else begin
        wptr_wclk <= nxt_wptr_wclk;
        wptr_gray <= nxt_wptr_gray;
    end
end
// 将输入数据写入当前写指针对应的存储单元内
always @(posedge wclk) 
begin
    if (wr_en == 1'b1)
        ram[wptr_wclk[DEEPTH_BIT-2:0]] <= dati;
    else ;
end

// 读指针更新
assign nxt_rptr_rclk = (rd_en && !empty) ? (rptr_rclk + 1'b1) : rptr_rclk;
// 读指针转格雷码
assign nxt_rptr_gray = (nxt_rptr_rclk >> 1) ^ nxt_rptr_rclk;
// 读指针跳转
always @(posedge rclk or negedge rst_n) 
begin
    if (rst_n == 1'b0) begin
        rptr_rclk <= {DEEPTH_BIT{1'b0}};
        rptr_gray <= {DEEPTH_BIT{1'b0}};
    end    
    else if (rclr) begin
        rptr_rclk <= {DEEPTH_BIT{1'b0}};
        rptr_gray <= {DEEPTH_BIT{1'b0}};    
    end
    else begin
        rptr_rclk <= nxt_rptr_rclk;
        rptr_gray <= nxt_rptr_gray;
    end
end

// 将当前读指针对应的存储单元内数据取出
assign raddr = rptr_rclk[DEEPTH_BIT-2:0];
assign dato = ram[raddr];

// 在写指针视角下将读指针同步到写时钟下
always @(posedge wclk or negedge rst_n) 
begin
    if (rst_n == 1'b0) begin
        rptr_sp1 <= {DEEPTH_BIT{1'b0}};
        rptr_sp2 <= {DEEPTH_BIT{1'b0}};
    end    
    else begin
        rptr_sp1 <= rptr_gray;
        rptr_sp2 <= rptr_sp1;
    end
end

// 在读指针视角下将写指针同步到读时钟下
always @(posedge rclk or negedge rst_n) 
begin
    if (rst_n == 1'b0) begin
        wptr_sp1 <= {DEEPTH_BIT{1'b0}};
        wptr_sp2 <= {DEEPTH_BIT{1'b0}};
    end    
    else begin
        wptr_sp1 <= wptr_gray;
        wptr_sp2 <= wptr_sp1;
    end
end
// 空满判断，格雷码指针回卷后与
assign full = (wptr_gray == {~rptr_sp2[DEEPTH_BIT-1],~rptr_sp2[DEEPTH_BIT-2],rptr_sp2[DEEPTH_BIT-3:0]});
assign empty = (rptr_gray == wptr_sp2);

// FIFO level
// 格雷码转二进制码
assign wptr_bin[DEEPTH_BIT-1] = wptr_sp2[DEEPTH_BIT-1];
assign wptr_bin[DEEPTH_BIT-2] = (^wptr_sp2[DEEPTH_BIT-1:DEEPTH_BIT-2]);
assign wptr_bin[DEEPTH_BIT-3] = (^wptr_sp2[DEEPTH_BIT-2:DEEPTH_BIT-3]);
assign wptr_bin[DEEPTH_BIT-4] = (^wptr_sp2[DEEPTH_BIT-3:DEEPTH_BIT-4]);
assign wptr_bin[DEEPTH_BIT-5] = (^wptr_sp2[DEEPTH_BIT-4:DEEPTH_BIT-5]);
assign wptr_bin[DEEPTH_BIT-6] = (^wptr_sp2[DEEPTH_BIT-5:DEEPTH_BIT-6]);

assign rptr_bin[DEEPTH_BIT-1] = rptr_sp2[DEEPTH_BIT-1];
assign rptr_bin[DEEPTH_BIT-2] = (^rptr_sp2[DEEPTH_BIT-1:DEEPTH_BIT-2]);
assign rptr_bin[DEEPTH_BIT-3] = (^rptr_sp2[DEEPTH_BIT-2:DEEPTH_BIT-3]);
assign rptr_bin[DEEPTH_BIT-4] = (^rptr_sp2[DEEPTH_BIT-3:DEEPTH_BIT-4]);
assign rptr_bin[DEEPTH_BIT-5] = (^rptr_sp2[DEEPTH_BIT-4:DEEPTH_BIT-5]);
assign rptr_bin[DEEPTH_BIT-6] = (^rptr_sp2[DEEPTH_BIT-5:DEEPTH_BIT-6]);
// FIFO的读写水平
assign wlevel = wptr_wclk - rptr_bin;
assign rlevel = wptr_bin - rptr_rclk;

endmodule