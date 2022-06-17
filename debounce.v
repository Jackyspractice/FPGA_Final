module debounce(

    input wire inp,
    input wire clk,
    input reset,
    output wire outp

    );

     reg delay1;
     reg delay2;
     reg delay3;

     always @(posedge clk)
     begin

        delay1 <= inp;
        delay2 <= delay1;
        delay3 <= delay2;
        
     end
     
       assign outp = delay1 & delay2 & delay3;

endmodule