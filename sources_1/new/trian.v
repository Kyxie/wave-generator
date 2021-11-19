`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/22 19:21:05
// Design Name: 
// Module Name: trian
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


module Triangle(
        input clk,
        input [11:0] addr,
        output [7:0] dout2     
    );
triangular_rom D
      (
        .clka(clk),
        .addra(addr),
        .douta(dout2)
      );      
endmodule
