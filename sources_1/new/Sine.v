`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 19:20:50
// Design Name: 
// Module Name: Sine
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


module Sin(
        input clk,
        input [11:0] addr,
        output [7:0] dout1     
    );
sin_rom D
      (
        .clka(clk),
        .addra(addr),
        .douta(dout1)
      );      
endmodule
