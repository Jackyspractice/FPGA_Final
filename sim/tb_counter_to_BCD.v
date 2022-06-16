`timescale 1ms/1ns
module tb_counter_to_BCD();

reg clk;
reg reset;
wire [12:0] seconds;
wire [12:0] minutes;
wire [12:0] hours;
wire [12:0] small_sec;

wire [3:0] small_ONES, small_TENS, small_HUNDREDS, small_thousands;
wire [3:0] second_ONES, second_TENS, second_HUNDREDS, second_thousands;
wire [3:0] min_ONES, min_TENS, min_HUNDREDS, min_thousands;
wire [3:0] hr_ONES, hr_TENS, hr_HUNDREDS, hr_thousands;

counter counter(
    .clk(clk), .reset(reset), .seconds_out(seconds), .minutes_out(minutes), .small_sec_out(small_sec),  .hours_out(hours)
);

BCD BCD_small(
    .A(small_sec),
    .ONES(small_ONES),
    .TENS(small_TENS),
    .HUNDREDS(small_HUNDREDS),
    .thousands(small_thousands)
);
BCD BCD_sec(
    .A(seconds),
    .ONES(second_ONES),
    .TENS(second_TENS),
    .HUNDREDS(second_HUNDREDS),
    .thousands(second_thousands)
);
BCD BCD_min(
    .A(minutes),
    .ONES(min_ONES),
    .TENS(min_TENS),
    .HUNDREDS(min_HUNDREDS),
    .thousands(min_thousands)
);
BCD BCD_hr(
    .A(hours),
    .ONES(hr_ONES),
    .TENS(hr_TENS),
    .HUNDREDS(hr_HUNDREDS),
    .thousands(hr_thousands)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    #10
    reset = 0;
end
endmodule 