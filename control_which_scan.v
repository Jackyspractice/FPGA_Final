module control_which_scan(
    input clk,

    output reg [1:0] sel
);

initial begin
    sel <= 0;
end

always @(posedge clk)
begin

    sel <= sel + 1;

end

endmodule
