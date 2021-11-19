`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 00:41:26
// Design Name: 
// Module Name: VGA
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


module VGA(
    input clk,
    input [3:0] Hun_Freq,
    input [3:0] Ten_Freq,
    input [3:0] One_Freq,
    input [3:0] Ten_Amp,
    input [3:0] One_Amp,
	
	input [11:0] sw,
	input [11:0]sine,
	input [11:0]square,
	input [11:0]triangle,
	output reg[15:0]addr,
	
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
    );
    parameter Ta = 80;  // Horizontal Factors
    parameter Tb = 160;
    parameter Tc = 800;
    parameter Td = 16;
    parameter Te = 1056;    // Vertical Factors
    parameter To = 3;
    parameter Tp = 21;
    parameter Tq = 600;
    parameter Tr = 1;
    parameter Ts = 625;
    
    reg [10:0] x_counter = 11'b0;   // Horizontal scanning progress 
    reg [10:0] y_counter = 11'b0;   // Vertical scanning progress
    reg [11:0] colour = 12'h000;
    
    reg [159:0] Frequency [31:0];
    reg [159:0] Amplitude [31:0];
    reg [31:0] Hz [31:0];
    reg [15:0] V [15:0];
    reg [15:0] N0 [31:0];
    reg [15:0] N1 [31:0];
    reg [15:0] N2 [31:0];
    reg [15:0] N3 [31:0];
    reg [15:0] N4 [31:0];
    reg [15:0] N5 [31:0];
    reg [15:0] N6 [31:0];
    reg [15:0] N7 [31:0];
    reg [15:0] N8 [31:0];
    reg [15:0] N9 [31:0];
    wire clk_vga;
    
clk_wiz_0 uut_clk                          
     (
          .clk_in1(clk),
          .clk_out1(clk_vga)
     );
    
    always @ (negedge clk_vga)
    begin
        begin
            if(x_counter == Te - 1)
            begin
                x_counter = 0;
                if(y_counter == Ts - 1)
                    y_counter = 0;
                else
                    y_counter = y_counter + 1;
            end
            else
                x_counter = x_counter + 1;
        end
	
	/////////////////////////////////////////////////////////////////////////
        begin
            if((x_counter>=0+Ta+Tb && x_counter<=800+Ta+Tb) && (y_counter>=296+To+Tp && y_counter<=600+To+Tp))
                colour<=12'h000;
            else if((x_counter>=240+Ta+Tb && x_counter<=800+Ta+Tb) && (y_counter>=0+To+Tp && y_counter<=600+To+Tp))
                colour<=12'h000;
            else if((x_counter>=160+Ta+Tb && x_counter<=160+16+Ta+Tb) && (y_counter>=372+To+Tp && y_counter<=372+32+To+Tp))
                colour<=12'h000;
            else if((x_counter>=160+16*4+Ta+Tb && x_counter<=160+16*5+Ta+Tb) && (y_counter>=240+32+To+Tp && y_counter<=240+32+32+To+Tp))
                colour<=12'h000;
            else if((x_counter>=0+Ta+Tb && x_counter<=240+Ta+Tb) && (y_counter>=120+To+Tp && y_counter<=240+To+Tp))
                colour<=12'h000;
        end
        
        /////////////////////////////////////////////////////////////////////////////
        begin
        if((y_counter>=(To+Tp))&&(y_counter<(To+Tp+120)))
            if((x_counter>=(Ta+Tb))&&(x_counter<(Ta+Tb+240)))//rectify
                begin
                if(x_counter>=(Ta+Tb+240))//rectify
                    addr=addr;
                else addr=addr+1;
                if(x_counter>=(Ta+Tb))
                    case(sw[1:0])
                    2'b00: colour = square;
                    2'b01: colour = sine;
                    2'b11: colour = triangle;
                    endcase
                else
                    colour = 12'h000;
                end
            else
                begin
                addr=addr;
                // colour=12'h000;
                end
        else
            begin
            addr = 16'hffff;//rec
            //colour1 = 12'h000;
            end
        end
        ///////////////////////////////////////////////////////////
        
        
        begin   // Freq
            if(((x_counter>=0+Ta+Tb) && (x_counter<=160+Ta+Tb)) && ((y_counter>=240+To+Tp) && (y_counter<=240+32+To+Tp)))
            begin
                if(Frequency[y_counter-(Ta+Tb+32+24)][(160+Ta+Tb)-x_counter])
                    colour<=12'hfff;        
                else
                    colour<=12'h000;
            end       
        end
        begin
            if(((x_counter>=0+Ta+Tb) && (x_counter<=160+Ta+Tb)) && ((y_counter>=240+32+To+Tp) && (y_counter<=240+32+32+To+Tp)))
            begin
                if(Amplitude[y_counter-(240+32+32+To+Tp)][(160+Ta+Tb)-x_counter])
                    colour<=12'hfff;        
                else
                    colour<=12'h000;
            end        
        end
        begin
            if(((x_counter>=160+16+16+16+Ta+Tb) && (x_counter<=160+16*3+32+Ta+Tb)) && ((y_counter>=240+To+Tp) && (y_counter<=240+32+To+Tp)))
            begin
                if(Hz[y_counter-(240+32+To+Tp)][(160+16*3+32+Ta+Tb)-x_counter])
                    colour<=12'hfff;        
                else
                    colour<=12'h000;
            end        
        end
        begin
            if(((x_counter>=208+Ta+Tb) && (x_counter<=224+Ta+Tb)) && ((y_counter>=272+To+Tp) && (y_counter<=304+To+Tp)))
            begin
                if(V[y_counter-(304+To+Tp)][(224+Ta+Tb)-x_counter])
                    colour<=12'hfff;        
                else
                    colour<=12'h000;
            end        
        end
        begin   // Freq first
            if(((x_counter>=160+Ta+Tb) && (x_counter<=160+16+Ta+Tb)) && ((y_counter>=240+To+Tp) && (y_counter<=240+32+To+Tp)))
            begin
                case(Hun_Freq)
                    4'd0:
                    begin
                        if(N0[y_counter-(240+32+To+Tp)][(160+16+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd1:
                    begin
                        if(N1[y_counter-(240+32+To+Tp)][(160+16+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd2:
                    begin
                        if(N2[y_counter-(240+32+To+Tp)][(160+16+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    default:
                    begin
                        if(N0[y_counter-(240+32+To+Tp)][(160+16+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                endcase
            end        
        end
        begin   // Freq second
            if(((x_counter>=160+16+Ta+Tb) && (x_counter<=160+32+Ta+Tb)) && ((y_counter>=240+To+Tp) && (y_counter<=240+32+To+Tp)))
            begin
                case(Ten_Freq)
                    4'd0:
                    begin
                        if(N0[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd1:
                    begin
                        if(N1[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd2:
                    begin
                        if(N2[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd3:
                    begin
                        if(N3[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd4:
                    begin
                        if(N4[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd5:
                    begin
                        if(N5[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd6:
                    begin
                        if(N6[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd7:
                    begin
                        if(N7[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd8:
                    begin
                        if(N8[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd9:
                    begin
                        if(N9[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    default:
                    begin
                        if(N0[y_counter-(240+32+To+Tp)][(160+32+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                endcase
            end        
        end
        begin   // Freq third
            if(((x_counter>=192+Ta+Tb) && (x_counter<=208+Ta+Tb)) && ((y_counter>=240+To+Tp) && (y_counter<=240+32+To+Tp)))
            begin
                case(One_Freq)
                    4'd0:
                    begin
                        if(N0[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd1:
                    begin
                        if(N1[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd2:
                    begin
                        if(N2[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd3:
                    begin
                        if(N3[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd4:
                    begin
                        if(N4[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd5:
                    begin
                        if(N5[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd6:
                    begin
                        if(N6[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd7:
                    begin
                        if(N7[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd8:
                    begin
                        if(N8[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd9:
                    begin
                        if(N9[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    default:
                    begin
                        if(N0[y_counter-(240+32+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                endcase
            end        
        end
        begin   // Amp first
            if(((x_counter>=160+16+Ta+Tb) && (x_counter<=192+Ta+Tb)) && ((y_counter>=240+32+To+Tp) && (y_counter<=240+64+To+Tp)))
            begin
                case(Ten_Amp)
                    4'd0:
                    begin
                        if(N0[y_counter-(240+64+To+Tp)][(192+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd1:
                    begin
                        if(N1[y_counter-(240+64+To+Tp)][(192+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    default:
                    begin
                        if(N0[y_counter-(240+64+To+Tp)][(192+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                endcase
            end        
        end
        begin   // Amp second
            if(((x_counter>=192+Ta+Tb) && (x_counter<=208+Ta+Tb)) && ((y_counter>=240+32+To+Tp) && (y_counter<=240+64+To+Tp)))
            begin
                case(One_Amp)
                    4'd0:
                    begin
                        if(N0[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd1:
                    begin
                        if(N1[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd2:
                    begin
                        if(N2[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd3:
                    begin
                        if(N3[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd4:
                    begin
                        if(N4[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd5:
                    begin
                        if(N5[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd6:
                    begin
                        if(N6[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd7:
                    begin
                        if(N7[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd8:
                    begin
                        if(N8[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    4'd9:
                    begin
                        if(N9[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                    default:
                    begin
                        if(N0[y_counter-(240+64+To+Tp)][(208+Ta+Tb)-x_counter])
                            colour<=12'hfff;        
                        else
                            colour<=12'h000;
                    end
                endcase
            end        
        end
	///////////////////////////////////////////////////////////////////////////////
        begin
            Frequency[0 ] <= 160'h0000000000000000000000000000000000000000;
            Frequency[1 ] <= 160'h0000000000000000000000000000000000000000;
            Frequency[2 ] <= 160'h0000000000000000000000000000000000000000;
            Frequency[3 ] <= 160'h0000000000000000000000000000000000000000;
            Frequency[4 ] <= 160'h0000000000000000000000000000000000000000;
            Frequency[5 ] <= 160'h0000000000000000000000000000000000000000;
            Frequency[6 ] <= 160'h7FFC000000000000000000000000000000000000;
            Frequency[7 ] <= 160'h181C000000000000000000000000000000000000;
            Frequency[8 ] <= 160'h1804000000000000000000000000000000000000;
            Frequency[9 ] <= 160'h1802000000000000000000000000000000000000;
            Frequency[10] <= 160'h1802000000000000000000000000000000000000;
            Frequency[11] <= 160'h1800000000000000000000000000000000000000;
            Frequency[12] <= 160'h1800000000000000080800000000000000000000;
            Frequency[13] <= 160'h1810061C03C003C8787803C009E003E07C3E0180;
            Frequency[14] <= 160'h18107E660C300C7818180C307A300E10181803C0;
            Frequency[15] <= 160'h1830068608181838181808181C180C18181003C0;
            Frequency[16] <= 160'h1FF0078018081818181818081818181808100180;
            Frequency[17] <= 160'h18300700300C30181818300C181830180C100000;
            Frequency[18] <= 160'h18100600300C30181818300C1818300004200000;
            Frequency[19] <= 160'h18100600300C30181818300C1818300006200000;
            Frequency[20] <= 160'h181006003FFC301818183FFC1818300006200000;
            Frequency[21] <= 160'h1800060030003018181830001818300002400000;
            Frequency[22] <= 160'h1800060030003018181830001818300003400000;
            Frequency[23] <= 160'h1800060030003018181830001818300401400000;
            Frequency[24] <= 160'h1800060018041018181818041818180401800180;
            Frequency[25] <= 160'h18000600180818381838180818181808018003C0;
            Frequency[26] <= 160'h180006000E180C780C5E0E1818180C10010003C0;
            Frequency[27] <= 160'h7E007FE003E00798079003E07E7E03E001000180;
            Frequency[28] <= 160'h0000000000000018000000000000000001000000;
            Frequency[29] <= 160'h0000000000000018000000000000000002000000;
            Frequency[30] <= 160'h000000000000001800000000000000003E000000;
            Frequency[31] <= 160'h000000000000007E00000000000000003C000000;
        end
        begin
            Amplitude[0 ] <= 160'h0000000000000000000000000000000000000000;
            Amplitude[1 ] <= 160'h0000000000000000000000000000000000000000;
            Amplitude[2 ] <= 160'h0000000000000000000000000000000000000000;
            Amplitude[3 ] <= 160'h0000000000000000000000000000000000000000;
            Amplitude[4 ] <= 160'h0000000000000000000000000000000000000000;
            Amplitude[5 ] <= 160'h0000000000000080000000000000000800000000;
            Amplitude[6 ] <= 160'h03C0000000001F80018000000000007800000000;
            Amplitude[7 ] <= 160'h03C000000000018003C000000000001800000000;
            Amplitude[8 ] <= 160'h03C0000000000180018001000000001800000000;
            Amplitude[9 ] <= 160'h07C0000000000180000001000000001800000000;
            Amplitude[10] <= 160'h07E0000000000180000001000000001800000000;
            Amplitude[11] <= 160'h06E0000000000180000003000000001800000000;
            Amplitude[12] <= 160'h06E0200000000180008007000808001800000000;
            Amplitude[13] <= 160'h0EE0EF3C09E001801F803FF8787807D803C00180;
            Amplitude[14] <= 160'h0EF071C67A3001800180030018180C380C3003C0;
            Amplitude[15] <= 160'h0CF061861C1801800180030018181818081803C0;
            Amplitude[16] <= 160'h0C70618618080180018003001818181818080180;
            Amplitude[17] <= 160'h1C706186180C01800180030018183018300C0000;
            Amplitude[18] <= 160'h1C786186180C01800180030018183018300C0000;
            Amplitude[19] <= 160'h1FF86186180C01800180030018183018300C0000;
            Amplitude[20] <= 160'h18786186180C018001800300181830183FFC0000;
            Amplitude[21] <= 160'h38386186180C0180018003001818301830000000;
            Amplitude[22] <= 160'h38386186180C0180018003001818301830000000;
            Amplitude[23] <= 160'h303C6186180C0180018003001818301830000000;
            Amplitude[24] <= 160'h303C618618180180018003041818101818040180;
            Amplitude[25] <= 160'h701C61861C1801800180030418381838180803C0;
            Amplitude[26] <= 160'h701E61861E300180018001880C5E0C5E0E1803C0;
            Amplitude[27] <= 160'hFC7FF3CF19E01FF81FF800F00790079003E00180;
            Amplitude[28] <= 160'h0000000018000000000000000000000000000000;
            Amplitude[29] <= 160'h0000000018000000000000000000000000000000;
            Amplitude[30] <= 160'h0000000018000000000000000000000000000000;
            Amplitude[31] <= 160'h000000007E000000000000000000000000000000;
        end
        begin
            Hz[0 ] <= 32'h00000000;
            Hz[1 ] <= 32'h00000000;
            Hz[2 ] <= 32'h00000000;
            Hz[3 ] <= 32'h00000000;
            Hz[4 ] <= 32'h00000000;
            Hz[5 ] <= 32'h00000000;
            Hz[6 ] <= 32'hFE7F0000;
            Hz[7 ] <= 32'h781E0000;
            Hz[8 ] <= 32'h781C0000;
            Hz[9 ] <= 32'h781C0000;
            Hz[10] <= 32'h781C0000;
            Hz[11] <= 32'h781C0000;
            Hz[12] <= 32'h781C0000;
            Hz[13] <= 32'h781C3FF8;
            Hz[14] <= 32'h781C3038;
            Hz[15] <= 32'h781C3030;
            Hz[16] <= 32'h7FFC2060;
            Hz[17] <= 32'h781C20E0;
            Hz[18] <= 32'h781C00C0;
            Hz[19] <= 32'h781C0180;
            Hz[20] <= 32'h781C0380;
            Hz[21] <= 32'h781C0300;
            Hz[22] <= 32'h781C0600;
            Hz[23] <= 32'h781C0E04;
            Hz[24] <= 32'h781C0C04;
            Hz[25] <= 32'h781C180C;
            Hz[26] <= 32'h781E3018;
            Hz[27] <= 32'hFE7F3FF8;
            Hz[28] <= 32'h00000000;
            Hz[29] <= 32'h00000000;
            Hz[30] <= 32'h00000000;
            Hz[31] <= 32'h00000000;
        end
        begin
            V[0 ] <= 16'h0000;
            V[1 ] <= 16'h0000;
            V[2 ] <= 16'h0000;
            V[3 ] <= 16'h0000;
            V[4 ] <= 16'h0000;
            V[5 ] <= 16'h0000;
            V[6 ] <= 16'h7C1E;
            V[7 ] <= 16'h180C;
            V[8 ] <= 16'h1808;
            V[9 ] <= 16'h1808;
            V[10] <= 16'h1808;
            V[11] <= 16'h0C10;
            V[12] <= 16'h0C10;
            V[13] <= 16'h0C10;
            V[14] <= 16'h0C10;
            V[15] <= 16'h0C20;
            V[16] <= 16'h0620;
            V[17] <= 16'h0620;
            V[18] <= 16'h0620;
            V[19] <= 16'h0640;
            V[20] <= 16'h0340;
            V[21] <= 16'h0340;
            V[22] <= 16'h0340;
            V[23] <= 16'h0380;
            V[24] <= 16'h0180;
            V[25] <= 16'h0180;
            V[26] <= 16'h0100;
            V[27] <= 16'h0100;
            V[28] <= 16'h0000;
            V[29] <= 16'h0000;
            V[30] <= 16'h0000;
            V[31] <= 16'h0000;
        end
        begin
            N0[0 ] <= 16'h0000;
            N0[1 ] <= 16'h0000;
            N0[2 ] <= 16'h0000;
            N0[3 ] <= 16'h0000;
            N0[4 ] <= 16'h0000;
            N0[5 ] <= 16'h0000;
            N0[6 ] <= 16'h07E0;
            N0[7 ] <= 16'h0FF0;
            N0[8 ] <= 16'h1C38;
            N0[9 ] <= 16'h3C3C;
            N0[10] <= 16'h3C1C;
            N0[11] <= 16'h781C;
            N0[12] <= 16'h781E;
            N0[13] <= 16'h781E;
            N0[14] <= 16'h781E;
            N0[15] <= 16'h781E;
            N0[16] <= 16'h781E;
            N0[17] <= 16'h781E;
            N0[18] <= 16'h781E;
            N0[19] <= 16'h781E;
            N0[20] <= 16'h781E;
            N0[21] <= 16'h781E;
            N0[22] <= 16'h781C;
            N0[23] <= 16'h383C;
            N0[24] <= 16'h3C3C;
            N0[25] <= 16'h1C38;
            N0[26] <= 16'h0FF0;
            N0[27] <= 16'h07E0;
            N0[28] <= 16'h0000;
            N0[29] <= 16'h0000;
            N0[30] <= 16'h0000;
            N0[31] <= 16'h0000;
        end
        begin
            N1[0 ]<= 16'h0000;
            N1[1 ]<= 16'h0000;
            N1[2 ]<= 16'h0000;
            N1[3 ]<= 16'h0000;
            N1[4 ]<= 16'h0000;
            N1[5 ]<= 16'h0000;
            N1[6 ]<= 16'h00C0;
            N1[7 ]<= 16'h03C0;
            N1[8 ]<= 16'h1FC0;
            N1[9 ]<= 16'h03C0;
            N1[10]<= 16'h03C0;
            N1[11]<= 16'h03C0;
            N1[12]<= 16'h03C0;
            N1[13]<= 16'h03C0;
            N1[14]<= 16'h03C0;
            N1[15]<= 16'h03C0;
            N1[16]<= 16'h03C0;
            N1[17]<= 16'h03C0;
            N1[18]<= 16'h03C0;
            N1[19]<= 16'h03C0;
            N1[20]<= 16'h03C0;
            N1[21]<= 16'h03C0;
            N1[22]<= 16'h03C0;
            N1[23]<= 16'h03C0;
            N1[24]<= 16'h03C0;
            N1[25]<= 16'h03C0;
            N1[26]<= 16'h03E0;
            N1[27]<= 16'h1FFC;
            N1[28]<= 16'h0000;
            N1[29]<= 16'h0000;
            N1[30]<= 16'h0000;
            N1[31]<= 16'h0000;
        end
        begin
            N2[0 ] <= 16'h0000;
            N2[1 ] <= 16'h0000;
            N2[2 ] <= 16'h0000;
            N2[3 ] <= 16'h0000;
            N2[4 ] <= 16'h0000;
            N2[5 ] <= 16'h0000;
            N2[6 ] <= 16'h0FF0;
            N2[7 ] <= 16'h1E78;
            N2[8 ] <= 16'h383C;
            N2[9 ] <= 16'h381C;
            N2[10] <= 16'h781C;
            N2[11] <= 16'h781C;
            N2[12] <= 16'h7C1C;
            N2[13] <= 16'h381C;
            N2[14] <= 16'h003C;
            N2[15] <= 16'h0038;
            N2[16] <= 16'h0070;
            N2[17] <= 16'h00F0;
            N2[18] <= 16'h01E0;
            N2[19] <= 16'h03C0;
            N2[20] <= 16'h0780;
            N2[21] <= 16'h0F00;
            N2[22] <= 16'h0E06;
            N2[23] <= 16'h1C0E;
            N2[24] <= 16'h380C;
            N2[25] <= 16'h701C;
            N2[26] <= 16'h7FFC;
            N2[27] <= 16'h7FFC;
            N2[28] <= 16'h0000;
            N2[29] <= 16'h0000;
            N2[30] <= 16'h0000;
            N2[31] <= 16'h0000;
        end
        begin
            N3[0 ] <= 16'h0000;
            N3[1 ] <= 16'h0000;
            N3[2 ] <= 16'h0000;
            N3[3 ] <= 16'h0000;
            N3[4 ] <= 16'h0000;
            N3[5 ] <= 16'h0000;
            N3[6 ] <= 16'h0FE0;
            N3[7 ] <= 16'h1CF0;
            N3[8 ] <= 16'h3878;
            N3[9 ] <= 16'h383C;
            N3[10] <= 16'h383C;
            N3[11] <= 16'h383C;
            N3[12] <= 16'h003C;
            N3[13] <= 16'h0038;
            N3[14] <= 16'h0078;
            N3[15] <= 16'h01F0;
            N3[16] <= 16'h07E0;
            N3[17] <= 16'h00F8;
            N3[18] <= 16'h0038;
            N3[19] <= 16'h001C;
            N3[20] <= 16'h001E;
            N3[21] <= 16'h001E;
            N3[22] <= 16'h381E;
            N3[23] <= 16'h781E;
            N3[24] <= 16'h781C;
            N3[25] <= 16'h383C;
            N3[26] <= 16'h3CF8;
            N3[27] <= 16'h0FE0;
            N3[28] <= 16'h0000;
            N3[29] <= 16'h0000;
            N3[30] <= 16'h0000;
            N3[31] <= 16'h0000;
        end
        begin
            N4[0 ] <= 16'h0000;
            N4[1 ] <= 16'h0000;
            N4[2 ] <= 16'h0000;
            N4[3 ] <= 16'h0000;
            N4[4 ] <= 16'h0000;
            N4[5 ] <= 16'h0000;
            N4[6 ] <= 16'h0070;
            N4[7 ] <= 16'h0070;
            N4[8 ] <= 16'h00F0;
            N4[9 ] <= 16'h01F0;
            N4[10] <= 16'h01F0;
            N4[11] <= 16'h03F0;
            N4[12] <= 16'h0370;
            N4[13] <= 16'h0770;
            N4[14] <= 16'h0E70;
            N4[15] <= 16'h0C70;
            N4[16] <= 16'h1C70;
            N4[17] <= 16'h1870;
            N4[18] <= 16'h3870;
            N4[19] <= 16'h7070;
            N4[20] <= 16'h6070;
            N4[21] <= 16'hFFFF;
            N4[22] <= 16'h0070;
            N4[23] <= 16'h0070;
            N4[24] <= 16'h0070;
            N4[25] <= 16'h0070;
            N4[26] <= 16'h00F8;
            N4[27] <= 16'h07FE;
            N4[28] <= 16'h0000;
            N4[29] <= 16'h0000;
            N4[30] <= 16'h0000;
            N4[31] <= 16'h0000;
        end
        begin
            N5[0 ] <= 16'h0000;
            N5[1 ] <= 16'h0000;
            N5[2 ] <= 16'h0000;
            N5[3 ] <= 16'h0000;
            N5[4 ] <= 16'h0000;
            N5[5 ] <= 16'h0000;
            N5[6 ] <= 16'h1FFC;
            N5[7 ] <= 16'h1FFC;
            N5[8 ] <= 16'h3800;
            N5[9 ] <= 16'h3800;
            N5[10] <= 16'h3800;
            N5[11] <= 16'h3800;
            N5[12] <= 16'h3800;
            N5[13] <= 16'h39C0;
            N5[14] <= 16'h3FF0;
            N5[15] <= 16'h3E78;
            N5[16] <= 16'h383C;
            N5[17] <= 16'h381C;
            N5[18] <= 16'h001E;
            N5[19] <= 16'h001E;
            N5[20] <= 16'h001E;
            N5[21] <= 16'h381E;
            N5[22] <= 16'h781E;
            N5[23] <= 16'h781C;
            N5[24] <= 16'h781C;
            N5[25] <= 16'h383C;
            N5[26] <= 16'h1E78;
            N5[27] <= 16'h0FF0;
            N5[28] <= 16'h0000;
            N5[29] <= 16'h0000;
            N5[30] <= 16'h0000;
            N5[31] <= 16'h0000;
        end
        begin
            N6[0 ] <= 16'h0000;
            N6[1 ] <= 16'h0000;
            N6[2 ] <= 16'h0000;
            N6[3 ] <= 16'h0000;
            N6[4 ] <= 16'h0000;
            N6[5 ] <= 16'h0000;
            N6[6 ] <= 16'h03F0;
            N6[7 ] <= 16'h0F38;
            N6[8 ] <= 16'h1E3C;
            N6[9 ] <= 16'h1C3C;
            N6[10] <= 16'h3818;
            N6[11] <= 16'h3800;
            N6[12] <= 16'h7800;
            N6[13] <= 16'h7800;
            N6[14] <= 16'h7FF0;
            N6[15] <= 16'h7FF8;
            N6[16] <= 16'h7C3C;
            N6[17] <= 16'h781E;
            N6[18] <= 16'h781E;
            N6[19] <= 16'h781E;
            N6[20] <= 16'h781E;
            N6[21] <= 16'h781E;
            N6[22] <= 16'h781E;
            N6[23] <= 16'h381E;
            N6[24] <= 16'h3C1C;
            N6[25] <= 16'h1C1C;
            N6[26] <= 16'h1F78;
            N6[27] <= 16'h07F0;
            N6[28] <= 16'h0000;
            N6[29] <= 16'h0000;
            N6[30] <= 16'h0000;
            N6[31] <= 16'h0000;
        end
        begin
            N7[0 ] <= 16'h0000;
            N7[1 ] <= 16'h0000;
            N7[2 ] <= 16'h0000;
            N7[3 ] <= 16'h0000;
            N7[4 ] <= 16'h0000;
            N7[5 ] <= 16'h0000;
            N7[6 ] <= 16'h3FFE;
            N7[7 ] <= 16'h3FFE;
            N7[8 ] <= 16'h381C;
            N7[9 ] <= 16'h3018;
            N7[10] <= 16'h7038;
            N7[11] <= 16'h2030;
            N7[12] <= 16'h0070;
            N7[13] <= 16'h0060;
            N7[14] <= 16'h00E0;
            N7[15] <= 16'h00E0;
            N7[16] <= 16'h01C0;
            N7[17] <= 16'h01C0;
            N7[18] <= 16'h03C0;
            N7[19] <= 16'h0380;
            N7[20] <= 16'h0380;
            N7[21] <= 16'h0380;
            N7[22] <= 16'h0780;
            N7[23] <= 16'h0780;
            N7[24] <= 16'h0780;
            N7[25] <= 16'h0780;
            N7[26] <= 16'h0780;
            N7[27] <= 16'h0780;
            N7[28] <= 16'h0000;
            N7[29] <= 16'h0000;
            N7[30] <= 16'h0000;
            N7[31] <= 16'h0000;
        end
        begin
            N8[0 ] <= 16'h0000;
            N8[1 ] <= 16'h0000;
            N8[2 ] <= 16'h0000;
            N8[3 ] <= 16'h0000;
            N8[4 ] <= 16'h0000;
            N8[5 ] <= 16'h0000;
            N8[6 ] <= 16'h0FF0;
            N8[7 ] <= 16'h1E78;
            N8[8 ] <= 16'h381C;
            N8[9 ] <= 16'h781C;
            N8[10] <= 16'h701E;
            N8[11] <= 16'h701E;
            N8[12] <= 16'h781C;
            N8[13] <= 16'h3C1C;
            N8[14] <= 16'h3E38;
            N8[15] <= 16'h1FF0;
            N8[16] <= 16'h0FE0;
            N8[17] <= 16'h1DF8;
            N8[18] <= 16'h38F8;
            N8[19] <= 16'h783C;
            N8[20] <= 16'h701E;
            N8[21] <= 16'h701E;
            N8[22] <= 16'h701E;
            N8[23] <= 16'h701E;
            N8[24] <= 16'h701C;
            N8[25] <= 16'h381C;
            N8[26] <= 16'h1E78;
            N8[27] <= 16'h0FF0;
            N8[28] <= 16'h0000;
            N8[29] <= 16'h0000;
            N8[30] <= 16'h0000;
            N8[31] <= 16'h0000;
        end
        begin
            N9[0 ] <= 16'h0000;
            N9[1 ] <= 16'h0000;
            N9[2 ] <= 16'h0000;
            N9[3 ] <= 16'h0000;
            N9[4 ] <= 16'h0000;
            N9[5 ] <= 16'h0000;
            N9[6 ] <= 16'h0FE0;
            N9[7 ] <= 16'h1EF0;
            N9[8 ] <= 16'h3838;
            N9[9 ] <= 16'h783C;
            N9[10] <= 16'h781C;
            N9[11] <= 16'h701E;
            N9[12] <= 16'h701E;
            N9[13] <= 16'h701E;
            N9[14] <= 16'h701E;
            N9[15] <= 16'h781E;
            N9[16] <= 16'h783E;
            N9[17] <= 16'h787E;
            N9[18] <= 16'h3FFE;
            N9[19] <= 16'h1FDE;
            N9[20] <= 16'h001E;
            N9[21] <= 16'h001C;
            N9[22] <= 16'h003C;
            N9[23] <= 16'h1838;
            N9[24] <= 16'h3C38;
            N9[25] <= 16'h3C70;
            N9[26] <= 16'h3DE0;
            N9[27] <= 16'h1FC0;
            N9[28] <= 16'h0000;
            N9[29] <= 16'h0000;
            N9[30] <= 16'h0000;
            N9[31] <= 16'h0000;
        end
    end
    
    always @ (x_counter or y_counter)
    begin
        
    end
    
    assign  vgaRed={colour[11:8]};                                          
    assign  vgaGreen={colour[7:4]};
    assign  vgaBlue={colour[3:0]};
    assign Hsync = !(x_counter < Ta);
    assign Vsync = !(y_counter < To);
endmodule