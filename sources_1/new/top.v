`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 09:50:54
// Design Name: 
// Module Name: top
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


module top(
input clk,
output DAC_CS,
output DAC_WR,
output DACAB,
output [7:0]DAC_DATA,
output [11:0]led,
input  [11:0]sw,
input rxd,

output Hsync,
output Vsync,
output[3:0]vgaRed,
output[3:0]vgaGreen,
output[3:0]vgaBlue,

output [7:0]seg,
output [5:0]bit
    );
wire clk_16u;
wire clk_seg;
wire clk_5M;   
wire [7:0]dout;
wire [7:0]dout1;
wire [7:0]dout2;
wire [11:0]addr1;

wire [7:0]data_disp;

wire [11:0]Dout;
wire [11:0]Dout1;
wire [11:0]Dout2;
wire [15:0]addr;

wire [4:0] Hun_Freq;
wire [4:0] Ten_Freq;
wire [4:0] One_Freq;
wire [4:0] Ten_Amp;
wire [4:0] One_Amp;
display a(
.clk_seg(clk_seg),
.seg(seg),
.bit(bit),
.dispfreqz(data_disp),//5 6位显示输入频率
.Amp(sw[5:2]),
.dispdata(sw[1:0])//1 2位显示选择波形
);
  
clk_div b(
.clk(clk),
.freqz(data_disp),
.clk_seg(clk_seg),
.clk_5M(clk_5M),
.clk_16u(clk_16u)
);

Test c(
.DAC_CS(DAC_CS),
.DAC_WR(DAC_WR),
.DACAB(DACAB),
.DAC_DATA(DAC_DATA),
.sw(sw),
.led(led),
.clk_5M(clk_5M),
.data_in(dout),
.data_in1(dout1),
.data_in2(dout2),
.addr1(addr1)
);

Receive d(
.clk_16u(clk_16u),
.rxd(rxd),
.data_disp(data_disp),
.data_ready(0),
.data_error(0)
);


square A(
.clk(clk_5M),
.addr(addr1),
.dout(dout)
);

Sin B(
.clk(clk_5M),
.addr(addr1),
.dout1(dout1)
);

Triangle C(
.clk(clk_5M),
.addr(addr1),
.dout2(dout2)
);



VGA v_wave(
    .clk(clk),
    .sine(Dout),
    .square(Dout1),
    .triangle(Dout2),
    .sw(sw),
       
.Hun_Freq(Hun_Freq),
.Ten_Freq(Ten_Freq),
.One_Freq(One_Freq),
.Ten_Amp(Ten_Amp),
.One_Amp(One_Amp), 
       
    .Hsync(Hsync),
    .Vsync(Vsync),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .addr(addr)  
    
    
    
     
);

v_bram v_bram1(
    .clk(clk),
    .addr1(addr),
    .Dout(Dout),
    .Dout1(Dout1),
    .Dout2(Dout2)
);

Transform_Freq Transform_Freq1(
.data_receive({4'b0, data_disp}),
.one(One_Freq),
.ten(Ten_Freq),
.hundred(Hun_Freq),
.thousand(0)
);

Transform_Amp Transform_Amp1(
.data_receive({8'b0,sw[5:2]}),
.one(One_Amp),
.ten(Ten_Amp),
.hundred(0),
.thousand(0)
);

endmodule


