`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/27 20:26:41
// Design Name: 
// Module Name: delay_i
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


module delay_i(
input [23:0] in_i,
input clk,
input reset_n,
input median_frame_clken     ,

output  [23:0] out_i
);
reg  [2:0]   int;
reg [23:0] delay_register0;
reg [23:0] delay_register1;
reg [23:0] delay_register2;
reg [23:0] delay_register3;
reg [23:0] delay_register4;
reg [23:0] delay_register5;
reg [23:0] delay_register6;
reg [23:0] delay_register7;
reg [23:0] delay_register8;
reg [23:0] delay_register9;
reg [23:0] delay_register10;

reg [6:0] median_frame_clken_r;

wire de_o;

//assign out_i=delay_register6;
assign out_i = de_o ? delay_register6 : 0;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n )
    begin
   
       delay_register0 <=0; 
       delay_register1<=0; 
       delay_register2<=0; 
       delay_register3<=0; 
       delay_register4<=0; 
       delay_register5<=0;
       delay_register6<=0;
     end 
     else 
       begin
     
        delay_register0  <=in_i;
        delay_register1  <=delay_register0;
        delay_register2  <=delay_register1;
        delay_register3  <=delay_register2;
        delay_register4 <=delay_register3;
        delay_register5 <=delay_register4;
        delay_register6 <=delay_register5;
    end
   end
//assign pos_frame_vsync = median_frame_vsync_r[6];
//assign pos_frame_href = median_frame_href_r[6];
assign de_o = median_frame_clken_r[6];
    //延迟6个周期进行同步
always@(posedge clk or negedge reset_n)begin
   if(!reset_n)begin
  // median_frame_vsync_r <= 0;
  // median_frame_href_r <= 0;
   median_frame_clken_r <= 0;
   end
   else begin
  // median_frame_vsync_r <= {median_frame_vsync_r[1:0],median_frame_vsync};
  // median_frame_href_r <= {median_frame_href_r [1:0], median_frame_href};
   median_frame_clken_r <= {median_frame_clken_r[5:0],median_frame_clken};
   end
   end  
   
endmodule
  



