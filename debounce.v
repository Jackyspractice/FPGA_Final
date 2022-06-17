module debounce(

input wire inp,
input wire clk,
output wire outp

);

reg delay1;
reg delay2;
reg delay3;

initial begin
   delay1 <= 0;
   delay2 <= 0;
   delay3 <= 0;
end

always @(posedge clk)
begin

   delay1 <= inp;
   delay2 <= delay1;
   delay3 <= delay1 & delay2;
   
end

assign outp = delay1 & delay2 & ~delay3;

endmodule
