module counter_parallel_to_series (clk , rst_n , parallel_in , serial_out , en , EOC);
    input clk , rst_n , en;
    input [7:0] parallel_in;
    output reg serial_out , EOC;
    reg [2:0] count;

    always @(posedge clk) begin
        if(~rst_n) begin 
            count <= 0;
            EOC <= 0;
            serial_out <= 0;
        end
        else if(en) begin
            serial_out <= parallel_in[count];
            count <= count + 1;

            if(count == 6) begin
                //count <= 0;
                EOC <= 1;
            end
            else if(count == 7) begin
                count <= 0;
               // EOC <= 0;
            end
            else
                EOC <= 0;
        end
        else begin
            serial_out <= 0;
            EOC <= 0;
            count <= 0;
        end
    end

endmodule