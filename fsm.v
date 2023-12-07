module fsm(

input wire sys_clk,
input wire sys_rst_n,
input wire out_flag,

output reg start,
output wire [7:0]spi_width,
output wire [1:0]spi_cmd,
output reg [7:0]index


);

reg [7:0]state; 

parameter IDIE = 8'd0,
				s0 = 8'd1,
				s1 = 8'd2,
				cnt_1s_max = 23'd999_999;//26'd49_999_999
				
reg [22:0]cnt_1s;


assign spi_width = 7'd8;
assign spi_cmd = 2'd0;



always @(posedge sys_clk or negedge sys_rst_n)
			if(sys_rst_n == 1'b0)
				cnt_1s <= 23'd0;
			else if(cnt_1s == cnt_1s_max)
				cnt_1s <= 23'd0;
			else if(state == IDIE)
				cnt_1s <= cnt_1s + 23'd1;
			else	
				cnt_1s <= 23'd0;

				


				
				
always @(posedge sys_clk or negedge sys_rst_n)
			if(sys_rst_n == 1'b0)
				state <= IDIE;
			else 
				case(state)
					IDIE :
						if(cnt_1s == cnt_1s_max)
							state <= s0;
						else
							state <= state;
					s0 :
						if(index < 8'd1 && out_flag == 1'b1)
							state <= s1;
						else if(index == 8'd1 && out_flag == 1'b1)
							state <= IDIE;
						else	
							state <= state;
					s1 :
						if(index <= 8'd1)
							state <= s0;
						
						else
							state <= state;
					default : state <= state;
				endcase
			

always @(posedge sys_clk or negedge sys_rst_n)
			if(sys_rst_n == 1'b0)
				index <= 8'd0;
			else if(index == 8'd1 && out_flag == 1'b1)
				index <= 8'd0;
			else if(out_flag == 1'b1)
				index <= index + 8'd1;
			else
				index <= index;
				
				
always @(posedge sys_clk or negedge sys_rst_n)
			if(sys_rst_n == 1'b0)
				start <= 1'b0;
			else if(cnt_1s == cnt_1s_max || (state == s1 && index <= 8'd1))
				start <= 1'b1;
			else
				start <= 1'b0;
			

endmodule
