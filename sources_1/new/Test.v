`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/20 16:06:50
// Design Name: 
// Module Name: Test
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
module Test(
input [7:0]data_in,
input [7:0]data_in1,
input [7:0]data_in2,

input  [11:0]sw,//12位控制波形，00方波 10sin 11triangle
input clk_5M,

output DAC_CS,
output DAC_WR,
output DACAB,
output [7:0]DAC_DATA,
output [11:0]led,
output [11:0]addr1
    );

reg [11:0]addr=12'b0;
reg [7:0]DATA_IN;

reg [3:0]Amp=4'b10;

assign DAC_CS = sw[11];
assign DAC_WR = sw[10];
assign DACAB = sw[9];
assign led=sw;
assign DAC_DATA = DATA_IN[7:0];

always@(sw)
begin
Amp<=sw[5:2];
case(sw[1:0])
2'b00:DATA_IN=data_in*10/(100/Amp);//
2'b01:DATA_IN=data_in1*10/(100/Amp);
2'b11:DATA_IN=data_in2*10/(100/Amp);
default:DATA_IN=0;
endcase
end

always@(posedge clk_5M)//T=4096*0.0000002  f=1/T=1220hz      
begin
if(addr==12'b111111111111)
    begin
    addr<=0;
    end
else addr=addr+1;//+2 f2=488.28   
end
assign addr1=addr;


endmodule
/*

display a(
.clk_seg(clk_seg),
.seg(seg),
.bit(bit),
.dispdata(sw[7:0])
);

*/
    


