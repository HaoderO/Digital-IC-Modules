`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module min_rgb(
    input         pixelclk,
	input         reset_n ,
    input  [23:0] i_rgb   ,
	input		  i_clken ,
	input		  i_vsync ,
	input		  i_de    ,
    
    output [ 7:0] min_rgb , 
	output        o_hsync ,
	output        o_vsync ,                                                                                                  
	output        o_de          
    );
    
    wire [7:0] r;
    wire [7:0] g;
    wire [7:0] b; 
    reg [7:0] min;
    
    reg [7:0] m_hsync;
    reg [7:0] m_vsync;
    reg [7:0] m_de;
    
    assign   r = i_rgb[23:16];
    assign   g = i_rgb[15:8];
    assign   b = i_rgb[7:0];
    assign   min_rgb = min;
    assign   o_hsync=  m_hsync;
    assign   o_vsync=  m_vsync;
    assign   o_de =    m_de   ;  
     
   
 //找出rgb通道最小值 
   
 always @(posedge pixelclk or negedge reset_n) 
    if(!reset_n) begin     
           min<=8'b0 ;
    end
    else begin
        if (r <= g && r <= b) begin
            min<= r;
        end
        else if (g <= r && g <= b) begin
            min<= g;
        end
        else begin
            min <= b;
        end
    end
    
 //行同步，场同步，数据使能延迟一个时钟
 always @(posedge pixelclk or negedge reset_n) 
    if(!reset_n) begin    
        m_hsync<= 1'd0;       
        m_vsync<= 1'd0;
        m_de   <= 1'd0;
    end
    else begin
        m_hsync<=i_clken;
        m_vsync<=i_vsync;
        m_de   <=i_de; 
    end  
              
endmodule
