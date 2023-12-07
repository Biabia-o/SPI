module SPI_MO(

input wire sys_clk,
input wire sys_rst_n,
input wire [7:0]spi_width,
input wire [1:0]spi_cmd,
input wire start,
input wire [7:0]data,

output wire SPI_clk,
output reg CS,
output reg MOSI,
output reg out_flag

);


wire sys_clk_fan;

assign sys_clk_fan = ~sys_clk;


reg [7:0]cnt_8;
reg en;

reg [7:0]state;

parameter IDIE = 8'd0,
				s1 = 8'd1,
				s2 = 8'd2,
				s3 = 8'd3,
				s4 = 8'd4,
				s5 = 8'd5;

				
always @(posedge sys_clk or negedge sys_rst_n)
				if(sys_rst_n == 1'b0)
					state <= IDIE;
				else 
					case(state)
					IDIE :
						if(start == 1'b1)	
							state <= s1;
						else
							state <= state;
					s1 :
						state <= s2;
					s2 :
						if(cnt_8 == spi_width)
							state <= s3;
						else
							state <= state;
					s3 :
						state <= s4;
					s4 :
						state <= s5;
					s5 :
						state <= IDIE;
					default : state <= IDIE;
					endcase
				
always @(posedge sys_clk or negedge sys_rst_n)
				if(sys_rst_n == 1'b0)				
					cnt_8 <= 8'd0;
				else if(cnt_8 == spi_width )
					cnt_8 <= 8'd0;
				else if(state == s2)
					cnt_8 <= cnt_8 + 8'd1;
				else
					cnt_8 <= 8'd0;
				
always @(posedge sys_clk or negedge sys_rst_n)
				if(sys_rst_n == 1'b0)
					en <= 1'b0;
				else if((cnt_8 >= 8'd0 && cnt_8 <= spi_width) && state == s2)
					en <= 1'b1;
				else
					en <= 1'b0;
					
				
assign SPI_clk = (cnt_8 >= 8'd1 && cnt_8 <= 8'd8)?(sys_clk_fan):(1'b0);
				
				

				
				

always @(posedge sys_clk or negedge sys_rst_n)
				if(sys_rst_n == 1'b0)
					CS <= 1'b1;
				else if(state == s1)
					CS <= 1'b0;
				else if(state == s4)
					CS <= 1'b1;
				else
					CS <= CS;
					
					
always @(posedge sys_clk or negedge sys_rst_n)
				if(sys_rst_n == 1'b0)
					MOSI <= 1'b0;
				else if(CS == 1'b0)
					case(cnt_8)
//						8'd0 : MOSI <= data[23];
//						8'd1 : MOSI <= data[22];
//						8'd2 : MOSI <= data[21];
//						8'd3 : MOSI <= data[20];
//						8'd4 : MOSI <= data[19];
//						8'd5 : MOSI <= data[18];
//						8'd6 : MOSI <= data[17];
//						8'd7 : MOSI <= data[16];
//						8'd8 : MOSI <= data[15];
//						8'd9 : MOSI <= data[14];
//						8'd10 : MOSI <= data[13];
//						8'd11 : MOSI <= data[12];
//						8'd12 : MOSI <= data[11];
//						8'd13 : MOSI <= data[10];
//						8'd14 : MOSI <= data[9];
//						8'd15 : MOSI <= data[8];
						8'd0 : MOSI <= data[7];
						8'd1 : MOSI <= data[6];
						8'd2 : MOSI <= data[5];
						8'd3 : MOSI <= data[4];
						8'd4 : MOSI <= data[3];
						8'd5 : MOSI <= data[2];
						8'd6 : MOSI <= data[1];
						8'd7 : MOSI <= data[0];
						default : MOSI <= 1'b0;
					endcase
					

always @(posedge sys_clk or negedge sys_rst_n)
				if(sys_rst_n == 1'b0)
					out_flag <= 1'b0;
				else if(state == s5)
					out_flag <= 1'b1;
				else
					out_flag <= 1'b0;
				
				
				

endmodule
