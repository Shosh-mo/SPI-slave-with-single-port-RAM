module SPI_wrapper_tb ();
    reg clk,rst_n,SS_n,MOSI;
    wire MISO;
    SPI_wrapper test (MOSI,MISO,SS_n,clk,rst_n);
    
    initial begin
    clk=0;
    forever 
    #1 clk=~clk;
    end
    

    //integer i;

    initial begin
        rst_n=0;
        SS_n=0;
        repeat(2)
            @(posedge clk);
        MOSI=0;
        rst_n=1;
        SS_n=1; //#1
        
         @(posedge clk);
        //testing the write by entering 10'b00 0000 0000; 
        //the address is 0000 0000
        SS_n = 0;
        MOSI = 0;
        repeat(9)  //#2 --> 10
             @(posedge clk);

        //entering the data to be written
        //data is 1111 1111
        MOSI = 0;  //#1
        @(posedge clk);
        MOSI = 1;  //#2

         @(posedge clk);
        MOSI = 1; //#3 --> 10
        repeat(8)
            @(posedge clk);


        MOSI = 1; // #1
        SS_n = 1;   //back to idle
        @(posedge clk);
        

        //testing the read
        // read address is 0000 0000

        SS_n = 0;
        MOSI = 0;   //#2 --> 10
        repeat(9)
            @(posedge clk);


        MOSI = 1;  //#1
        SS_n = 1; //back to idle
        @(posedge clk);
        SS_n = 0;
        MOSI = 1;  //#2
            @(posedge clk);
        MOSI = 0; //#3 --> 10
        repeat(8)
            @(posedge clk);

        repeat(10)  //1 clk in the RAM and 1 clk to put the data for conversion and 8 clocks for conversion
            @(posedge clk);
        ////////////////////////////////////////////////////////////////////////////////
        MOSI=0; //#1
        rst_n=1;
        SS_n=1; 
         @(posedge clk);
        //testing the write by entering 10'b00 0000 1111; 
        //the address is 0000 1111
        SS_n = 0;
        MOSI = 0; //#2 --> 6
        repeat(5)
            @(posedge clk); 

        MOSI = 1;
        repeat(4)  //#7 --> 10
             @(posedge clk);

        //entering the data to be written
        //data is 1010 1010
        MOSI = 0;  //#1
        @(posedge clk);
        MOSI = 1;  //#2
         @(posedge clk);

        MOSI = 1; //#3
            @(posedge clk);
        MOSI = 0; //#4
            @(posedge clk);
        MOSI = 1; //#5
            @(posedge clk);
        MOSI = 0; //#6
            @(posedge clk);
        MOSI = 1; //#7
            @(posedge clk);
        MOSI = 0; //#8
            @(posedge clk);
        MOSI = 1; //#9
            @(posedge clk);
        MOSI = 1; //#10
            @(posedge clk);



        MOSI = 1; // #1
        SS_n = 1;   //back to idle
        @(posedge clk);
        

        //testing the read
        // read address is 0000 1111

        SS_n = 0;
        MOSI = 0;   //#2
            @(posedge clk);
        MOSI = 0; //#3 --> 6
        repeat(4)
            @(posedge clk); 

        MOSI = 1;
        repeat(4)  //#7 --> 10
             @(posedge clk);


        MOSI = 1;  //#1
        SS_n = 1; //back to idle
        @(posedge clk);
        SS_n = 0;
        MOSI = 1;  //#2
            @(posedge clk);
        MOSI = 0; //#3 --> 10
        repeat(8)
            @(posedge clk);

        repeat(10)
            @(posedge clk);

        SS_n = 1;
        repeat(10)
             @(posedge clk);
        /////////////////////////////////////////////
        MOSI=0; //#1
        rst_n=1;
        SS_n=1; 
         @(posedge clk);
        //testing the write by entering 10'b00 1111 0000; 
        //the address is 1111 0000
        SS_n = 0;
        MOSI = 0; //#2
        @(posedge clk)
        MOSI = 1;  //#3 --> 6
        repeat(4)
            @(posedge clk); 

        MOSI = 0;
        repeat(4)  //#7 --> 10
             @(posedge clk);

        //entering the data to be written
        //data is 1010 1010
        MOSI = 0;  //#1
        @(posedge clk);
        MOSI = 1;  //#2
         @(posedge clk);

        MOSI = 1; //#3
            @(posedge clk);
        MOSI = 1; //#4
            @(posedge clk);
        MOSI = 1; //#5
            @(posedge clk);
        MOSI = 0; //#6
            @(posedge clk);
        MOSI = 0; //#7
            @(posedge clk);
        MOSI = 1; //#8
            @(posedge clk);
        MOSI = 0; //#9
            @(posedge clk);
        MOSI = 1; //#10
            @(posedge clk);



        MOSI = 1; // #1
        SS_n = 1;   //back to idle
        @(posedge clk);
        

        //testing the read
        // read address is 0000 1111

        SS_n = 0;
        MOSI = 0;   //#2
            @(posedge clk);
        MOSI = 1; //#3 --> 6
        repeat(4)
            @(posedge clk); 

        MOSI = 0;
        repeat(4)  //#7 --> 10
             @(posedge clk);


        MOSI = 1;  //#1
        SS_n = 1; //back to idle
        @(posedge clk);
        SS_n = 0;
        MOSI = 1;  //#2
            @(posedge clk);
        MOSI = 0; //#3 --> 10
        repeat(8)
            @(posedge clk);

        repeat(10)
            @(posedge clk);

        SS_n = 1;
        repeat(10)
             @(posedge clk);
        

        $stop;
    end
endmodule
