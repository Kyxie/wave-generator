`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/20 17:53:34
// Design Name: 
// Module Name: sim
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


module sim(

    );
reg clk=0;
reg [11:0]sw=0;
wire DAC_CS;
wire DAC_WR;
wire DACAB;
wire [7:0]DAC_DATA;


top test1(
.clk(clk),
.DAC_CS(DAC_CS),
.DAC_WR(DAC_WR),
.DACAB(DACAB),
.DAC_DATA(DAC_DATA),
.sw(sw)
//.led(led)
//.seg(seg),
//.bit(bit)
);
always # 10 clk=~clk;
/*initial
begin
clk=0;

sw=12'b111111111111;
#100
sw=12'b000011111111;

#80000 $stop;
end
always #5 clk=~clk;
*/

endmodule
