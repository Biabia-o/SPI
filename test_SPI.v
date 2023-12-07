module test_SPI(

input wire sys_clk,
input wire sys_rst_n,

output wire SPI_clk,
output wire CS,
output wire MOSI



);

wire SCK_5MHz;

wire [7:0]spi_width;
wire [1:0]spi_cmd; 
wire out_flag;
wire start;
wire [7:0] index;
wire [7:0] spi_wrdata;


fenpin fenpin(

. sys_clk(sys_clk),
. sys_rst_n(sys_rst_n),

. SCK_5MHz(SCK_5MHz)

);


SPI_MO SPI_MO(

. sys_clk(SCK_5MHz),
. sys_rst_n(sys_rst_n),
. spi_width(spi_width),
. spi_cmd(spi_cmd),  
. start(start),
. data(spi_wrdata),

. SPI_clk(SPI_clk),
. CS(CS),
. MOSI(MOSI),
. out_flag(out_flag)

);



fsm fsm(

. sys_clk(SCK_5MHz),
. sys_rst_n(sys_rst_n),
. out_flag(out_flag),

. start(start),
. spi_width(spi_width),
. spi_cmd(spi_cmd),
. index(index)

);


hmc_7044_cfg_data hmc_7044_cfg_data(

. index(index),
. spi_wrdata(spi_wrdata)
		
);


endmodule
