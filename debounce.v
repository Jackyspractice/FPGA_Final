module debounce(

input wire inp,
input wire clk,
output wire outp

);

reg delay1;
reg delay2;
reg delay3;
reg delay4;

initial begin
   delay1 <= 0;
   delay2 <= 0;
   delay3 <= 0;
   delay4 <= 0;
end

always @(posedge clk)
begin

   delay1 <= inp;
   delay2 <= delay1;
   delay3 <= delay2;
   delay4 <= delay1 & delay2 & delay3;
   
end

assign outp = delay1 & delay2 & delay3 & ~delay4;

endmodule
