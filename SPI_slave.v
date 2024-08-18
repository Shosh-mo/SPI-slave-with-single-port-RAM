module SPI_slave ( MOSI , MISO , SS_n , clk , rst_n , rx_data , rx_valid , tx_data , tx_valid );

    parameter IDLE = 3'b000;
    parameter READ_DATA = 3'b001;
    parameter READ_ADD = 3'b010;
    parameter CHK_CMD = 3'b011;
    parameter WRITE = 3'b100;

    (* fsm_encoding = "gray" *)
   // (* fsm_encoding = "one_hot" *)
   // (* fsm_encoding = "sequential" *)
    reg [2:0] cs , ns;


    input MOSI , SS_n , clk , rst_n;
    input tx_valid;
    input [7:0] tx_data;
    output MISO;
    output reg [9:0] rx_data;
    output reg rx_valid;

    reg read_flag = 0;   //the internal signal that decides the next state is READ_ADD  or READ_DATA
    wire [9:0] parallel_out ;  //input to the RAM
    reg [7:0] parallel_in;    //output from the RAM
    wire EOC_s_to_p ;           //end of conversion flag of serial bits input into parallel "10 clks"
    wire EOC_p_to_s;
    reg en_p_to_s;

    counter counter1 ( .clk(clk) , .rst_n(rst_n) , .serial_in(MOSI) , .parallel_out(parallel_out) , .EOC(EOC_s_to_p)); //serial to parallel
    counter_parallel_to_series counter2 ( .clk(clk) , .rst_n(rst_n) , .parallel_in(parallel_in) , .serial_out(MISO) , .EOC(EOC_p_to_s) , .en(en_p_to_s));  //output logic of MISO

    //state memory
    always @(posedge clk) begin
        if(~rst_n) begin
            cs <= IDLE;
           // parallel_in <= 0;
        end
        else
            cs <= ns;  
    end

    //next state
    always @(*) begin
        case(cs)
            IDLE:
                if(SS_n) begin
                    ns = IDLE;
                   // en_s_to_p = 0;
                end
                else begin
                    ns = CHK_CMD;
                   // en_s_to_p = 0;
                end
            CHK_CMD:
                if(SS_n) begin
                    ns = IDLE;
                end
                else if(!parallel_out[9]) begin
                    ns = WRITE;
                end
                else if((parallel_out[9]) && (read_flag)) begin 
                    ns = READ_DATA;
                end
                else if((parallel_out[9]) && (!read_flag)) begin
                    ns = READ_ADD;
                end
                else
                    ns = cs;

            READ_ADD:   
                if(SS_n)
                    ns = IDLE;
                else begin
                    ns = READ_ADD;
                    read_flag = 1;
                end

            READ_DATA:   
                if(SS_n)
                    ns = IDLE;
                else if(~EOC_s_to_p) begin
                    ns = READ_DATA;
                    read_flag = 0;
                end
                else if(tx_valid == 1) begin
                    ns = READ_DATA;
                    read_flag = 0;
                end
                else if(~EOC_p_to_s) begin
                    ns = READ_DATA;
                end
                else begin
                    ns = READ_DATA;
                end 

            WRITE:
                if(SS_n)
                    ns = IDLE;
                else begin
                    ns = WRITE;
                end

            default: ns = IDLE;

        endcase
    end 

    //output logic
    always @(posedge clk) begin
        if(~rst_n) begin
            rx_data <= 0;
            rx_valid <= 0;
            parallel_in <= 0;
            en_p_to_s <= 0;
        end
        else if(((cs == READ_ADD) || (cs == READ_DATA)) && (EOC_s_to_p == 1)) begin
            rx_valid <= 1;
            rx_data <= parallel_out;
            en_p_to_s <= 0;
        end
        else if((cs == READ_DATA)&&(tx_valid == 1)) begin
            parallel_in <= tx_data;  // data is being converted from parallel to series
            rx_valid <= 0; ////////////////////////////////
            en_p_to_s <= 1;
            end
        else if(EOC_p_to_s) begin
            en_p_to_s <= 0;
        end
        else if ((cs == WRITE) && (EOC_s_to_p ==1)) begin
                    rx_valid <= 1;
                    rx_data <= parallel_out; 
        end 
        else
            rx_valid <= 0;
    end 

endmodule

