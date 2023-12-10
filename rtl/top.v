`timescale 1 ns/1 ns

module top
#(
    parameter               H_DISP = 1920       ,   //图像宽度
    parameter               V_DISP = 1080           //图像高度
)
(
    input   wire            clk                 ,   //时钟
    input   wire            rst_n               ,   //复位

    output  wire            VGA_hsync           ,   //VGA行同步
    output  wire            VGA_vsync           ,   //VGA场同步
    output  wire    [23:0]  VGA_data            ,   //VGA数据
    output  wire            VGA_de                  //VGA数据使能
);

    wire                    RGB_hsync           ;   //RGB行同步
    wire                    RGB_vsync           ;   //RGB场同步
    wire    [23:0]          RGB_data            ;   //RGB数据
    wire                    RGB_de              ;   //RGB数据使能

    wire                    DISP_hsync          ;   //RGB行同步
    wire                    DISP_vsync          ;   //RGB场同步
    wire    [15:0]          DISP_data           ;   //RGB数据
    wire                    DISP_de             ;   //RGB数据使能

img_gen
#(
    .H_DISP                 (H_DISP             ),  //图像宽度
    .V_DISP                 (V_DISP             )   //图像高度
)
u_img_gen
(
    .clk                    (clk                ),  //时钟
    .rst_n                  (rst_n              ),  //复位

    .img_hsync              (RGB_hsync          ),  //RGB行同步
    .img_vsync              (RGB_vsync          ),  //RGB场同步
    .img_data               (RGB_data           ),  //RGB数据，RGB888
    .img_de                 (RGB_de             )   //RGB数据使能
);

defogging_top defogging
(
    .pixelclk               (clk                ),
    .reset_n                (rst_n              ),
    .cmos_frame_ce          (RGB_hsync          ),
    .cmos_vsync             (RGB_vsync          ),
    .cmos_data              (RGB_data           ),
    .cmos_active_video      (RGB_de             ),

    .o_defog_hsync          (VGA_hsync          ), //clken
    .o_defog_vsync          (VGA_vsync          ),
    .o_defog_rgb1           (VGA_data           ),     
    .o_defog_de             (VGA_de             )  
); 

endmodule