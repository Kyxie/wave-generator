`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 15:16:30
// Design Name: 
// Module Name: vga_wave
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


module v_vga(
input clk,

input [11:0]sine,//data
input [11:0]square,
input [11:0]triangle,
input  [11:0]sw,

output Hsync,
output Vsync,
output[3:0]vgaRed,
output[3:0]vgaGreen,
output[3:0]vgaBlue,
output reg[15:0]addr


    );
//800*900 50Hz
parameter  ta=80,tb=160,tc=800,td=40,te=1056,to=3,tp=21,tq=600,tr=1,ts=625;  
reg[10:0] x_counter=0;                           
reg[10:0] y_counter=0;
reg [11:0] colour1;

wire clk_vga;
clk_wiz_0 uut_clk                          
     (
          .clk_in1(clk),
          .clk_out1(clk_vga)
     );
always@(negedge clk_vga) begin
    begin
        if(x_counter == te-1)
        begin
            x_counter=0;
            if(y_counter == ts-1)
            begin
                y_counter=0;
            end
            else
                y_counter = y_counter+1;
        end
        else
        begin
            x_counter = x_counter+1;
        
        if((y_counter>=(to+tp))&&(y_counter<(to+tp+120)))
            if((x_counter>=(ta+tb))&&(x_counter<(ta+tb+240)))//rectify
                begin
                if(x_counter>=(ta+tb+240))//rectify
                    addr=addr;
                else addr=addr+1;
                if(x_counter>=(ta+tb))
                    case(sw[1:0])
                    2'b00: colour1 = square;
                    2'b01: colour1 = sine;
                    2'b11: colour1 = triangle;
                    endcase
                else
                    colour1 = 12'h000;
                end
            else
                begin
                addr=addr;
                colour1=12'h000;
                end
        else
            begin
            addr = 16'hffff;//rec
            //colour1 = 12'h000;
            end
        end
    end
end

always@(x_counter or y_counter)            
begin


end
assign vgaRed[3:0] = colour1[11:8];
assign vgaGreen[3:0] = colour1[7:4];
assign vgaBlue[3:0] = colour1[3:0];
assign Hsync = !(x_counter<ta);
assign Vsync = !(y_counter<to);
                      
                          
endmodule
