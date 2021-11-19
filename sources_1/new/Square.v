`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 11:14:51
// Design Name: 
// Module Name: Square
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

module square(
        input clk,
        input [11:0] addr,
        output [7:0] dout     
    );
square_rom D
      (
        .clka(clk),
        .addra(addr),
        .douta(dout)
      );      
endmodule
