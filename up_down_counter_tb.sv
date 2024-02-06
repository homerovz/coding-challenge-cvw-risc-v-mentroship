
//-------------------------------------------------------------------------------------------
// Author:              Homero Vazquez
//
// Description:
//  This is a testbench to test the 
//  functionality of the up_down counter module
//  for the CORE-V Wally RISC-V Mentorship 
//  application.
//  
//  This testbench contains 3 tasks 
//  test_up: Which tests all the values when the counter is counting up
//  test_down: Which tests all the values when the counter is counting down
//  test_load: Which tests the values of the counter when it is loaded with some data 
//------------------------------------------------------------------------------------------
`timescale 1ns/1ns

module up_down_counter_TB;

    logic clk;
    logic reset;
    logic en;
    logic load;
    logic mode;

    logic[3:0] Din;
    logic[3:0] Qout;

    //Instatiate Device Under Test
    up_down_counter dut(.clk(clk), .reset(reset), .en(en), .load(load),
                        .mode(mode), .Din(Din), .Qout(Qout));

    //Generate Clock 
    always 
    begin
        #5 clk <= ~clk;
    end 
    
    //Task to test up counter
    task test_up();
        //Reset and check 
        #10 reset <= 1; 
        #10 assert(Qout == 0) else $error("Reset Wrong");
        //Enable and change mode to count up 
        #10 
        reset <= 0;
        en <= 1;
        mode <= 0; 
        //Test for the cases when the counter goes from 1 to 15
        #10 assert(Qout == 1) else $error("Up Count 1");
        #10 assert(Qout == 2) else $error("Up Count 2");
        #10 assert(Qout == 3) else $error("Up Count 3");
        #10 assert(Qout == 4) else $error("Up Count 4");
        #10 assert(Qout == 5) else $error("Up Count 5");
        #10 assert(Qout == 6) else $error("Up Count 6");
        #10 assert(Qout == 7) else $error("Up Count 7");
        #10 assert(Qout == 8) else $error("Up Count 8");
        #10 assert(Qout == 9) else $error("Up Count 9");
        #10 assert(Qout == 10) else $error("Up Count 10");
        #10 assert(Qout == 11) else $error("Up Count 11");
        #10 assert(Qout == 12) else $error("Up Count 12");
        #10 assert(Qout == 13) else $error("Up Count 13");
        #10 assert(Qout == 14) else $error("Up Count 14");
        #10 assert(Qout == 15) else $error("Up Count 15");
        //Wait for five cycles and check that the counter is circling back correctly 
        #50 assert(Qout == 4) else $error("Up Circling Back Wrong");
    endtask

    //Task to test down counter 
    task test_down();
        //Reset and check 
        #10 reset <=1;
        #10 assert(Qout == 0) else $error("Down Reset Wrong");
        //Enable and change mode to count down
        #10;
        reset <= 0;
        en <= 1;
        mode <= 1; 
        //Test for the cases when the counter goes from 15 to 1
        #10 assert(Qout == 15) else $error("Down Count 15");
        #10 assert(Qout == 14) else $error("Down Count 14");
        #10 assert(Qout == 13) else $error("Down Count 13");
        #10 assert(Qout == 12) else $error("Down Count 12");
        #10 assert(Qout == 11) else $error("Down Count 11");
        #10 assert(Qout == 10) else $error("Down Count 10");
        #10 assert(Qout == 9) else $error("Down Count 9");
        #10 assert(Qout == 8) else $error("Down Count 8");
        #10 assert(Qout == 7) else $error("Down Count 7");
        #10 assert(Qout == 6) else $error("Down Count 6");
        #10 assert(Qout == 5) else $error("Down Count 5");
        #10 assert(Qout == 4) else $error("Down Count 4");
        #10 assert(Qout == 3) else $error("Down Count 3");
        #10 assert(Qout == 2) else $error("Down Count 2");
        #10 assert(Qout == 1) else $error("Down Count 1");
        ////Wait for five cycles and check that the counter is circling back correctly 
        #50 assert(Qout == 12) else $error("Down Circling Back Wrong");
    endtask

    //Task to test loading a value Data to the counter 
    task test_load(input logic[3:0] Data);
        //Input Data and assert the load signal 
        #10 Din <= Data;
        #10 load <= 1;
        #10 load <= 0;
        //Make sure that our Data loads when enable is high 
        if(en == 1)
            assert(Qout == Data) else $error("Data was not loaded to the counter");

        #50; //Wait for 5 cycles and check if the counter is working properly with the loaded data 
        if(mode == 0 && en == 1)
            assert(Qout == Data+5) else $error("up counter not working Data = %h, Qout = %h",Data+5, Qout);
        else if(mode == 1 && en == 1)
            assert(Qout == Data-5) else $error("down counter not working Data = %h, Qout = %h",Data-5, Qout);
    endtask
    
    //Run the test bench 
    initial
    begin
        //Give initial values 
        clk <= 1;
        reset <= 1;
        en <= 0;
        load <= 0;
        mode <= 0;
        //Start testing the up counter 
        test_up();
        //Start testing the down counter 
        test_down();
        //Test the up/down counter and the load 
        #10
        test_load(4'hf);
        //Switch mode and test again 
        #10 mode <= 0;
        test_load(4'h1);
        //Test that enable works 
        #10
        en <= 0;
        test_load(4'hc);
        #50 $finish();
    end 

    initial 
    begin
        //Required to dump signals to EPWave 
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
endmodule 
