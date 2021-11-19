`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 15:57:11
// Design Name: 
// Module Name: ss
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


module Transform_Freq(
    input [11:0] data_receive,
    output reg [3:0] one,
    output reg [3:0] ten,
    output reg [3:0] hundred,
    output reg [2:0] thousand
    );
    
    integer i;
    always @ (data_receive)
    begin
        thousand = 4'd0;
        hundred = 4'd0;
        ten = 4'd0;
        one = 4'd0;
        
        for(i = 11; i >= 0; i = i - 1)
        begin
            if(thousand >= 4'd5)
                thousand = thousand + 2'd3;
            if(hundred >= 4'd5)
                hundred = hundred + 2'd3;
            if(ten >= 4'd5)
                ten = ten + 2'd3;
            if(one >= 4'd5)
                one = one + 2'd3;
            
            thousand = thousand << 1'b1;
            thousand[0] = hundred[3];
            hundred = hundred << 1'b1;
            hundred[0] = ten[3];
            ten = ten << 1'b1;
            ten[0] = one[3];
            one = one << 1'b1;
            one[0] = data_receive[i];
        end
    end
endmodule
