`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/20 16:10:44
// Design Name: 
// Module Name: display
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


module display(
input clk_seg,
input [1:0] dispdata,
input [7:0] dispfreqz,

input [3:0] Amp,

output reg [7:0] seg = 8'b0,
output reg [5:0] bit = 6'b111110
    );
    
reg[5:0] disp_dat = 4'b0;   // Data of Bit
reg[2:0] disp_bit = 3'b0;   // Bit Selection

always @ (posedge clk_seg)
    begin
        if(disp_bit >= 3'd5)    // Total Number of Bits
            disp_bit <= 3'd0;
        else
            disp_bit <= disp_bit + 1'd1;
        case(disp_bit)
            3'd0:
            begin
                bit <= 6'b111110;
                disp_dat <= dispdata[0];
            end
            3'd1:
            begin
                bit <= 6'b111101;
                disp_dat <= dispdata[1]; 
            end
            3'd2:
            begin
                bit <= 6'b111011;
                disp_dat <= Amp[3:0];//Amplitude
            end
            3'd3:
            begin
                bit <= 6'b110111;
                disp_dat <= 5'd16; 
            end
            3'd4:
            begin
                bit <= 6'b101111;
                disp_dat <= dispfreqz[3:0];  // Default, all off
            end
            3'd5:
            begin
                bit <= 6'b011111;
                disp_dat <= dispfreqz[7:4];
            end
        endcase
    end
    
    always @ (disp_dat)
    begin
        case(disp_dat)
            4'h0: seg = 8'h3f; //"0"
            4'h1: seg = 8'h06; //"1"
            4'h2: seg = 8'h5b; //"2"
            4'h3: seg = 8'h4f; //"3"
            4'h4: seg = 8'h66; //"4"
            4'h5: seg = 8'h6d; //"5"
            4'h6: seg = 8'h7d; //"6"
            4'h7: seg = 8'h07; //"7"
            4'h8: seg = 8'h7f; //"8"
            4'h9: seg = 8'h6f; //"9"
			4'ha : seg = 8'h77;
		    4'hb : seg = 8'h7c;
		    4'hc : seg = 8'h39;
		    4'hd : seg = 8'h5e;
		    4'he : seg = 8'h79;
		    4'hf : seg = 8'h71;
            default: seg = 8'h00; // All off
        endcase
    end
endmodule
