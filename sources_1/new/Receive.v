`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/24 13:28:13
// Design Name: 
// Module Name: Receive
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
module Receive(clk_16u, rxd, data_disp,data_ready, data_error);
input clk_16u;
input rxd;
output data_error; //奇偶校验
output data_ready; //当ready=1，开始接收
output [7:0]data_disp; //输出

reg data_ready,data_error;
reg[7:0]data_out=8'b0;
reg[11:0]data_out1=12'b0;
reg rxd_buf;
reg[15:0]clk_16x_cnt;
reg rxd1,rxd2;
reg start_flag;

parameter width=3;
parameter idle=1,one=2,two=3,stop=4; //状态机4状态
reg[width-1:0]present_state,next_state;




initial
begin
	clk_16x_cnt=0;
	present_state=idle;
	next_state=idle;
	rxd1=1'd1;
	rxd2=1'd1;
	data_ready='d0;
	start_flag=0;
end
always@(posedge clk_16u)
begin
	present_state<=next_state;
end
always@(clk_16x_cnt)
begin
	if(clk_16x_cnt<='d8)
		next_state=idle;
	if(clk_16x_cnt>'d8&&clk_16x_cnt<='d136)
		next_state=one;
	if(clk_16x_cnt>'d136&&clk_16x_cnt<='d152)
		next_state=two;
	if(clk_16x_cnt>'d152&&clk_16x_cnt<='d168)
		next_state=stop;
	if(clk_16x_cnt>'d168)
		next_state=idle;
end
always@(posedge clk_16u)
begin
	case(present_state)
	idle:
		begin
		rxd1<=rxd;
		rxd2<=rxd1;
		if((~rxd1)&&rxd2)
			start_flag<='d1;
		else
			if(start_flag==1)
				clk_16x_cnt<=clk_16x_cnt+'d1;
		end
	one:
		begin
		clk_16x_cnt<=clk_16x_cnt+'d1;
			if(clk_16x_cnt=='d24)data_out[0]<=rxd;
			else if(clk_16x_cnt=='d40)data_out[1]<=rxd;
			else if(clk_16x_cnt=='d56)data_out[2]<=rxd;
			else if(clk_16x_cnt=='d72)data_out[3]<=rxd;
			else if(clk_16x_cnt=='d88)data_out[4]<=rxd;
			else if(clk_16x_cnt=='d104)data_out[5]<=rxd;
			else if(clk_16x_cnt=='d120)data_out[6]<=rxd;
			else if(clk_16x_cnt=='d136)data_out[7]<=rxd;
		end
	two://奇偶校验位
		begin
			if(clk_16x_cnt=='d152)
			begin
				if(rxd_buf==rxd)data_error<=1'd1;//No error
				else data_error<=1'd1;
			end
			clk_16x_cnt<=clk_16x_cnt+'d1;
		end
	stop:
		begin
		if(clk_16x_cnt=='d168)
			begin
			if(1'd1==rxd)
				begin
					data_error<=1'd0;
					data_ready<=1'd1;
				end
			else
				begin
					data_error<=1'd1;
					data_ready<='d0;
				end
			end

		if(clk_16x_cnt>168)
			begin
			clk_16x_cnt<=0;
			start_flag<=0;
			end
		else
			clk_16x_cnt<=clk_16x_cnt+'d1;
		end
	endcase
end
assign data_disp[7:0]=data_out;
endmodule
