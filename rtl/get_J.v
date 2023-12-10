`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/25 20:22:22
// Design Name: 
// Module Name: get_J
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


module get_J(
    input         pixelclk       ,
	input         reset_n        ,	
    input  [ 23:0] i_rgb         ,
    input  [ 7:0 ]  at            ,
    input  [ 7:0 ]  a             ,    
	input         i_hsync        ,
	input         i_vsync        ,
	input         i_de           ,

    output [ 23:0] o_rgb          , 
	output         o_hsync        ,
	output         o_vsync        ,                                                                                                  
	output         o_de            
    );
 
 reg [24:0] red    ;
 reg [24:0] green  ;
 reg [24:0] blue   ;
 
 wire [7:0] i_red    ;
 wire [7:0] i_green  ;
 wire [7:0] i_blue   ;
wire [7:0]img_y ;
wire [7:0]img_cb;
wire [7:0]img_cr;
 
 assign img_y  = o_de ? red[7:0] : 8'd0;
 assign img_cb = o_de ? green[7:0]: 8'd0;
 assign img_cr = o_de ?blue [7:0]: 8'd0;
 
 assign o_rgb = {img_y,img_cb,img_cr};
 


 assign  i_red =i_rgb[23:16];
 assign  i_green=i_rgb[15:8 ];
 assign  i_blue =i_rgb[7:0];
 
 always @(posedge pixelclk or negedge reset_n) begin
    if(!reset_n) begin
        
        red    <=0;
        green  <=0;
        blue   <=0;
     end
     else begin
        red    <=5+a-((a-i_red   )*a/at);
        green  <=5+a-((a-i_green )*a/at); 
        blue   <=5+a-((a-i_blue  )*a/at); 
     end
     end 
     
//ÑÓ³ÙÒ»¸öÊ±ÖÓ
reg      o_hsync_m           ;
reg      o_vsync_m           ;
reg      o_de_m              ;
assign   o_hsync=o_hsync_m   ;
assign   o_vsync=o_vsync_m   ;
assign   o_de   =o_de_m      ;

always @(posedge pixelclk or negedge reset_n) begin
    if(!reset_n) begin
        o_hsync_m<=0;
        o_vsync_m<=0;
        o_de_m   <=0;
    end
    else begin
        o_hsync_m<=i_hsync;
        o_vsync_m<=i_vsync;
        o_de_m   <=i_de   ;
        end
    end              
endmodule
