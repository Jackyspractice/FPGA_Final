module sev_scan(sel, scan);

   input [1:0]sel;

   output [3:0] scan;

   reg [3:0] scan;

   always@(sel[1:0])

     case(sel[1:0])

       2'b00:scan = 4'b1110;// Enable AN1

       2'b01:scan = 4'b1101;// Enable AN2

       2'b10:scan = 4'b1011;// Enable AN3

       2'b11:scan = 4'b0111;// Enable AN4	

     endcase

endmodule

