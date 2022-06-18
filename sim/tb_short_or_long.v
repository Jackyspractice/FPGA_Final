module tb_short_or_long();

reg inc;
reg clk_1Hz;

wire inc_short;
wire inc_long;

short_or_long short_or_long(
    .inc(inc),
    .clk_1Hz(clk_1Hz),

    .inc_short(inc_short),
    .inc_long(inc_long)
);



always #5 clk_1Hz = ~clk_1Hz;

initial begin

    //intialize
    clk_1Hz = 0;
    inc = 0;
    #100
    //start
    inc = 1;
    #20
    inc = 0;
    #30
    inc = 1;
    #50
    inc = 0;
    #30
    inc = 1;
    #100
    inc = 0;
    #50
    $finish;
end

endmodule
