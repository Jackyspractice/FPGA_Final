`timescale 1ns/1ps
module FSM_testbench();

reg inc_short;
reg inc_long;
reg set;
reg sw;
reg clk;

wire counter_enable;

wire [1:0]mux;
//mux, choose to display counter or regtime, 
//[00, counter], [01, regtime], [10, regalarm], [11, regstopwatch]

wire mux_outmode;
//tell mux to output hr_min or min_sec
//[0, hr_min], [1, min_sec]

wire time_setting_enable;
wire time_hr_or_min;//regtime, to choose mode setting hr0 or min1
wire regalarm_setting_enable;
wire regalarm_hr_or_min;//regalarm, to choose mode setting hr0 or min1


FSM test(
    .clk(clk),
    .inc_short(inc_short),
    .inc_long(inc_long),
    .set(set),
    .sw(sw),
    
    .counter_enable(counter_enable),
    .mux(mux),
    .mux_outmode(mux_outmode),
    .time_setting_enable(time_setting_enable),
    .time_hr_or_min(time_hr_or_min),
    .regalarm_setting_enable(regalarm_setting_enable),
    .regalarm_hr_or_min(regalarm_hr_or_min)
);

initial begin
    //initialize
    clk = 0;
    inc_short = 0;
    inc_long = 0;
    set = 0;
    sw = 0;

    #50

    inc_short = 1;
    #10
    inc_short = 0;
    #10
    inc_short = 1;
    #10
    inc_short = 0;
    #10
    set = 1;
    #10
    set = 0;
    #10
    set = 1;
    #10
    set = 0;
    #10
    set = 1;
    #10
    set = 0;
    #10
    $finish;
    
end

always #5 clk = ~clk;

endmodule
