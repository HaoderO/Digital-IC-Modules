`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 10:36:02
// Design Name: 
// Module Name: dark_channel_image
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


module dark_channel_image(
    //时钟
    input       clk  ,  //50MHz
    input       rst_n,
    
    //处理前图像数据
    input       pre_gray_vsync,  //处理前图像数据场信号
    input       pe_gray_valid ,   //处理前图像数据行信号 
    input       pe_gray_clken ,   //处理前图像数据输入使能效信号
    input [7:0] min_rgb_m,        //rgb中最小值             
    
    //处理后的图像数据
    output       pos_gray_vsync,    //处理后的图像数据场信号   
    output       pos_gray_valid,    //处理后的图像数据行信号  
    output       pos_gray_clken,    //处理后的图像数据输出使能效信号
    output [7:0] dark_chanel_value   //处理后暗通道值    
    );
    
//wire define
wire        matrix_frame_vsync;
wire        matrix_frame_href;
wire        matrix_frame_clken;
wire [7:0]  matrix_p11; //3X3 阵列输出
wire [7:0]  matrix_p12; 
wire [7:0]  matrix_p13;
wire [7:0]  matrix_p21; 
wire [7:0]  matrix_p22; 
wire [7:0]  matrix_p23;
wire [7:0]  matrix_p31; 
wire [7:0]  matrix_p32; 
wire [7:0]  matrix_p33;
wire [7:0]  min_value;    

//*****************************************************
//**                    main code
//*****************************************************
//在延迟后的行信号有效，将中值赋给灰度输出值
assign dark_chanel_value = pos_gray_valid? min_value:8'd0;  

generate_3x3_8bit generate_3x3_8bit_1(
    .clk        (clk), 
    .rst_n      (rst_n),
    
    //处理前图像数据
    .per_frame_vsync    (pre_gray_vsync),
    .per_frame_href     (pe_gray_valid), 
    .per_frame_clken    (pe_gray_clken), 
    .per_img_y          (min_rgb_m),
    
    //处理后的图像数据
    .matrix_frame_vsync (matrix_frame_vsync),
    .matrix_frame_href  (matrix_frame_href),
    .matrix_frame_clken (matrix_frame_clken),
    .matrix_p11         (matrix_p11),    
    .matrix_p12         (matrix_p12),    
    .matrix_p13         (matrix_p13),
    .matrix_p21         (matrix_p21),    
    .matrix_p22         (matrix_p22),    
    .matrix_p23         (matrix_p23),
    .matrix_p31         (matrix_p31),    
    .matrix_p32         (matrix_p32),    
    .matrix_p33         (matrix_p33)
);

//3x3阵列的最小值值滤波，需要2个时钟
min_filter_3x3 min_filter_3x3_0(
    .clk        (clk),
    .rst_n      (rst_n),
    
    .median_frame_vsync (matrix_frame_vsync),
    .median_frame_href  (matrix_frame_href),
    .median_frame_clken (matrix_frame_clken),
    
    //第一行
    .data11           (matrix_p11)     , 
    .data12           (matrix_p12)     , 
    .data13           (matrix_p13)     ,
    //第二行              
    .data21           (matrix_p21)     , 
    .data22           (matrix_p22)     , 
    .data23           (matrix_p23)     ,
    //第三行              
    .data31           (matrix_p31)     , 
    .data32           (matrix_p32)     , 
    .data33           (matrix_p33)     ,
    
    .target_data      (min_value)      ,
    .pos_frame_vsync (pos_gray_vsync),
    .pos_frame_href  (pos_gray_valid) ,
    .pos_frame_clken (pos_gray_clken)
    
);

endmodule