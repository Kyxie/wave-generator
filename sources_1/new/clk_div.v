`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/20 17:09:14
// Design Name: 
// Module Name: clk_div
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


module clk_div (
	input	clk,			// 50M	20nm
	input   [7:0]freqz, //当输出频率=1220Hz时，对应5M时钟（200ns>50ns），DAC可以正常工作，串口输入最大255Hz
	output reg clk_5M =1'b0,    //1M 1us=(10^-6)s=1000nm  50M/1M=50,25   5M  200ns  50M/5M=10 10/2=5    
	output reg clk_16u = 1'b0, // 16*9600Hz
	output reg clk_seg = 1'b0 // 1kHz
    //output reg clk_scan = 1'b0
	);
	
//reg [5:0]       cnt_scan = 6'b0;
reg [7:0] cnt_16u = 8'b0;
reg [2:0]       cnt_1=3'b0;
reg [14:0] cnt_seg = 15'b0;
reg [10:0] cnt_5M = 6'b0;
//f_count=(50000000/(freqz*4096))/2
    
always @ (posedge clk)  // clk_seg
    begin
        if(cnt_seg >= 15'd25000) // 50M/1k = 50k; 50k/2 = 25k
        begin
            clk_seg <= ~clk_seg;
            cnt_seg <= 1'b0;
        end
        else
            cnt_seg <= cnt_seg + 1'b1;
    end
    
always @ (posedge clk)  // 提高晶振频率，减少图像精度
    begin
        if(cnt_5M >= (50000000/(freqz*4096*2))) //5     count=50M/2*4096*f
        begin
            clk_5M <= ~clk_5M;
            cnt_5M <= 1'b0;
        end
        else
            cnt_5M <= cnt_5M + 1'b1;
    end
    
always @ (posedge clk)  // clk_16u
    begin
        if(cnt_16u >= 8'd163) // 16*9.6k = 153600; 50M/153600 = 326; 326/2 = 163
        begin
            clk_16u <= ~clk_16u;
            cnt_16u <= 1'b0;
        end
        else
            cnt_16u <= cnt_16u + 1'b1;
    end
endmodule
