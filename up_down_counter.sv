//-----------------------------------------------------------------------
// Author:              Homero Vazquez
//
// Design Name:         Up-Down Counter 
// Mentorship Name:     CORE-V Wally Technology Readiness Level 5

// Description:
//  This is a SystemVerilog Module built for the 
//  Coding Challenge of the RISC-V Mentorship 
//  Application. 
//  This module is a 4-bit synchrunous up/down counter
//  with enable, asynchronous reset, and synchronous load.
//-----------------------------------------------------------------------

module up_down_counter( input logic         clk,
                                            reset,
                                            en,
                                            load,
                                            mode,//When mode is low up counter. When mode is high down counter

                        input logic[3:0]    Din,
                        
                        output logic[3:0]   Qout
                        );
    logic[3:0] Q; 
    
    always_ff @ (posedge clk or posedge reset) //Positive edge triggered and asynchronous reset
    begin
        //When the reset signal is high our output is 0
        if(reset)
        begin
            Q <= 0;
        end
        else if(en)
        begin
            //If load is high we load input Din into Q 
            if(load)
                Q <= Din; 
            else //Count up or down depending on the mode
            begin
                //When mode is high we count down
                //When mode is low we count up
                Q <= mode? Q-1:Q+1; 
            end
        end
        else
            Q <= Q; 
    end

    assign Qout = Q; 
endmodule 