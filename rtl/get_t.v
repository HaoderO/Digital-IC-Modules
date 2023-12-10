`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/23 11:13:07
// Design Name: 
// Module Name: get_t
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
module get_t(
    input         pixelclk         ,
	input         reset_n          ,
	
    input  [ 7:0] dark_chanel_value,
    input  [ 7:0] a                ,   
	input         i_hsync          ,
	input         i_vsync          ,
	input         i_de             ,

    output [ 7:0] at               ,     
	output        o_hsync          ,     
	output        o_vsync          ,                                                              
	output        o_de                   
    );
reg     [ 7:0] at_m                ;
assign   at=at_m                   ; 
    
always @(posedge pixelclk or negedge reset_n) begin
    if(!reset_n) 
        at_m<=0;
    else 
        at_m<=a-dark_chanel_value;
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





    

