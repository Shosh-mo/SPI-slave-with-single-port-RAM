module syn_RAM (din , rx_valid , dout , tx_valid , clk , rst_n);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input [9:0] din;
input rx_valid , clk , rst_n;
output reg [7:0] dout;
output reg tx_valid;

reg [ADDR_SIZE-1:0] read_write_address;

reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0] ;

always @(posedge clk) begin
    if(~rst_n) begin
        tx_valid <= 0;
        dout <= 0;
    end
    else if(rx_valid) begin
        case(din[9:8])
            2'b00: begin
                read_write_address <= din[ADDR_SIZE-1:0];
                tx_valid <= 0;
            end
            2'b01: begin
                mem[read_write_address] <= din[ADDR_SIZE-1:0];
                tx_valid <= 0;
            end
            2'b10: begin
                read_write_address <= din[ADDR_SIZE-1:0];
                tx_valid <= 0;
            end
            2'b11: begin
                dout[ADDR_SIZE-1:0] <= mem[read_write_address];
                tx_valid <= 1;
            end
            default: tx_valid <= 0;
        endcase
    end
    else
        tx_valid <= 0;
end
endmodule
