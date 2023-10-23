
module async_fifo_tb;

  // Parameters
  localparam  DEEPTH_BIT = 6;
  localparam  DEEPTH = 32;
  localparam  WIDTH = 8;

  //Ports
  reg                   wclk;
  reg                   rclk;
  reg                   wclr;
  reg                   rclr;
  reg                   rst_n;
  reg                   wr_en;
  reg                   rd_en;
  reg  [WIDTH-1:0]      dati;
  wire                  full;
  wire                  empty;
  wire [WIDTH-1:0]      dato;
  wire [DEEPTH_BIT-1:0] wlevel;
  wire [DEEPTH_BIT-1:0] rlevel;

async_fifo 
#(
    .DEEPTH_BIT (DEEPTH_BIT ),
    .DEEPTH     (DEEPTH     ),
    .WIDTH      (WIDTH      )
)
async_fifo_inst 
(
    .wclk       (wclk       ),
    .rclk       (rclk       ),
    .wclr       (wclr       ),
    .rclr       (rclr       ),
    .rst_n      (rst_n      ),
    .wr_en      (wr_en      ),
    .rd_en      (rd_en      ),
    .dati       (dati       ),
    .full       (full       ),
    .empty      (empty      ),
    .dato       (dato       ),
    .wlevel     (wlevel     ),
    .rlevel     (rlevel     )
);

always #5  wclk = ! wclk ;
always #10 rclk = ! rclk ;

initial begin
    wclk  = 0;
    rclk  = 0;
    wclr  = 1;
    rclr  = 1;
    rst_n = 0;
    wr_en = 0;
    rd_en = 0;
    dati  = 32'd0;
    #40
    wclr  = 0;
    rclr  = 0;
    rst_n = 1;
    #40
    wr_en = 1;
    rd_en = 0;
    #400
    wr_en = 0;
    rd_en = 1;
    #800
    wr_en = 0;
    rd_en = 0;
    wclr  = 1;
    rclr  = 1;
    #40
    $stop;
end

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)
        dati <= 32'd0;
    else if(wr_en == 1'b1)
        dati <= $random;
    else
        dati <= 32'd0;
end

endmodule