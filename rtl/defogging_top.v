`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/08 14:28:15
// Design Name: 
// Module Name: defogging_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module defogging_top (
      input  [23:0] cmos_data        ,
      input         cmos_active_video,
      input         cmos_vsync ,
      input         pixelclk,
      input         reset_n ,
      input         cmos_frame_ce,
      

      output                o_defog_de,      
      output        [23:0] o_defog_rgb1,
      output                o_defog_vsync,
      output                o_defog_hsync //clken
     
     ); 
	//input		  pixelclk     ,	//像素时钟
	//input         reset_n      ,	//低电平复位
	//input  [7:0] i_rgb        ,	//原始图像像素数据
	//input		  i_hsync      ,	//原始图像行同步
	//input		  i_vsync      ,	//原始图像场同步
	////input		  i_de         ,	//预处理图像时钟使能信号
	////output [7:0 ] dark_chanel_value  ,
	//output [23:0 ] o_defog_rgb  ,	//去雾图像像素数据
	//output		  o_defog_hsync,	//去雾图像行同步
	//output		  o_defog_vsync,	//去雾图像场同步    
	//output		  o_defog_de   , 	//去雾图像数据有效 
	//   
	//output		  cam_rst_n,
	//output        cam_pwdn, 
	//output        cmos_frame_clk, //时钟信号        
    //output        cmos_frame_ce     //时钟使能信号



wire [7:0] min_rgb_m ;
wire       o_hsync_m0;
wire       o_vsync_m0;
wire       o_de_m0   ;  

wire       o_hsync_m1;       
wire       o_vsync_m1;       
wire       o_de_m1;          
wire [7:0] dark_chanel_value; 

wire [7:0]        at  ;      
wire       o_hsync_m2 ;
wire       o_vsync_m2 ;
wire       o_de_m2    ; 
wire [23:0]out_i      ; 
parameter a=8'd255   ;


//capture_ip capture_ip1(
//    .cam_pclk         (pixelclk         ),
//    .rst_n            (reset_n          ),
//    .cam_vsync        (i_vsync          ),
//    .cam_href         (i_hsync          ),
//    .cam_data         (i_rgb            ),
//    
//    .cmos_frame_clk   (cmos_frame_clk   ),
//    .cmos_frame_ce    (cmos_frame_ce    ), //时钟使能
//    .cmos_vsync       (cmos_vsync       ), //场同步 
//    .cmos_active_video(cmos_active_video), //数据有效
//    .cmos_data        (cmos_data        ),                   
//    .cam_rst_n        (cam_rst_n        ),
//    .cam_pwdn         (cam_pwdn         )
//    );
    

min_rgb min_rgb_0(
        .pixelclk( pixelclk),
        .reset_n ( reset_n ),
        .i_rgb    (cmos_data),
        
      
        .i_vsync  (cmos_vsync        ),  //场有效
        .i_clken  (cmos_frame_ce     ),  //时钟使能
        .i_de     (cmos_active_video ),  //数据有效

        .min_rgb  (  min_rgb_m       ),
        .o_hsync  (  o_hsync_m0      ),
        .o_vsync  (  o_vsync_m0      ),
        .o_de     (  o_de_m0         )
);

dark_channel_image dark_channel_image_0(
        .clk                 (  pixelclk        ),
        .rst_n               (  reset_n         ),
        .min_rgb_m           (  min_rgb_m       ),
        .pe_gray_valid       (  o_de_m0      ),
        .pre_gray_vsync      (  o_vsync_m0      ), 
        .pe_gray_clken       (    o_hsync_m0    ), 
                                
        .pos_gray_vsync      ( o_vsync_m1       ),
        .pos_gray_valid      ( o_de_m1          ),
        .pos_gray_clken      (  o_hsync_m1      ),
        .dark_chanel_value   ( dark_chanel_value)        
);

get_t get_t0(
      .pixelclk           (  pixelclk       ),
      .reset_n            (  reset_n         ),
      .dark_chanel_value  (dark_chanel_value ),
      .a                  (a                 ),
      .i_hsync            (  o_hsync_m1      ),
      .i_vsync            (  o_vsync_m1      ),
      .i_de               (  o_de_m1         ),
      .at                 (  at              ),
      .o_hsync            (o_hsync_m2        ),
      .o_vsync            (o_vsync_m2        ),
      .o_de               (o_de_m2           )
);
     wire [23:0] in_i;
delay_i delay_i0(
     .in_i    (cmos_data         ),
     .clk     (pixelclk    ),
     .reset_n (reset_n           ),
     .median_frame_clken(cmos_active_video),
     .out_i   (out_i             )
     );
assign o_defog_rgb_2=24'b001111110000000000000000;
//wire [23:0] o_defog_rgb1 ;
get_J get_J0(
      .pixelclk            ( pixelclk  ),
      .reset_n             ( reset_n         ),
      .i_rgb               ( out_i           ),
      .at                  (at               ),
      .a                   (a                ),
      .i_hsync             (o_hsync_m2       ),
      .i_vsync             (o_vsync_m2       ),
      .i_de                (o_de_m2          ),
      
      .o_rgb               (o_defog_rgb1     ),
      .o_hsync             (o_defog_hsync    ),
      .o_vsync             (o_defog_vsync    ),
      .o_de                (o_defog_de       )
);

endmodule
