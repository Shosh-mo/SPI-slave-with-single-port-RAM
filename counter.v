module counter (clk , rst_n , serial_in , parallel_out , EOC);  //serial to parallel
    input clk , rst_n , serial_in;
    output reg [9:0] parallel_out;
    output reg EOC;

    reg [3:0] count;   //i want to count from 9 to 0 "10 times"

   always @(posedge clk) begin
    if(~rst_n) begin
        count <= 10;
        EOC <= 0;
        parallel_out <= 0;
    end
    else begin 
        count = count - 1;
        parallel_out[count] <= serial_in;  //parallel_out is now filled (10 bits) bit9 --> bit0

        if(count == 0) begin
            EOC <= 1;
            count <= 10;
        end
        else
            EOC <= 0;
    end
   end

endmodule


