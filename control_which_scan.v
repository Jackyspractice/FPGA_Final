module control_which_scan(
    input clk,
    input clr,

    output reg [1:0] sel
);

always @(posedge clk or posedge clr)
begin
    if (clr) sel <= 0;
    else sel <= sel + 1;
end

endmodule
