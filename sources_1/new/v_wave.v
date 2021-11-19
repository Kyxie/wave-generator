`timescale 1ns / 1ps


module v_bram(
        input clk,
        input [15:0] addr1,
        output [11:0] Dout,
        output [11:0] Dout1,
        output [11:0] Dout2             
    );
    
    
sin_wave Graph
      (
        .clka(clk),
        .addra(addr1),
        .douta(Dout)
      );      
square_wave Graph1
      (
        .clka(clk),
        .addra(addr1),
        .douta(Dout1)
      ); 
tri_wave Graph2
      (
        .clka(clk),
        .addra(addr1),
        .douta(Dout2)
      ); 
 
endmodule
