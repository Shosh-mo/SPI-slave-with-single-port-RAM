module SPI_wrapper (MOSI,MISO,SS_n,clk,rst_n);

    input MOSI,SS_n,clk,rst_n;
    output MISO;

    wire [9:0]rx_data;
    wire [7:0]tx_data;
    wire rx_valid,tx_valid;

    syn_RAM RAM_1 (.din(rx_data),.rx_valid(rx_valid),.tx_valid(tx_valid),.clk(clk),.rst_n(rst_n),.dout(tx_data));
    SPI_slave SPI_1 (MOSI , MISO , SS_n , clk , rst_n , rx_data , rx_valid , tx_data , tx_valid );

endmodule

