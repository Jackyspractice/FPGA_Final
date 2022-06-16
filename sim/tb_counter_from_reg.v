`timescale 1ms/1ns
module tb_counter_from_reg();

//tb input
reg clk_10000Hz;
reg reset;
reg inc_short;
reg time_setting_enable;
reg time_hr_or_min;
reg counter_enable;


/*******************************************/
//counter out
wire [13:0] seconds;
wire [13:0] minutes;
wire [13:0] hours;
wire [13:0] small_sec;
/*******************************************/


counter counter(
    .clk(clk_10000Hz),
    .reset(reset), 
    .enable(counter_enable),
    .setting_enable(time_setting_enable),
    .set_hr_or_min(time_hr_or_min),
    .inc_short(inc_short),

    .seconds_out(seconds), 
    .minutes_out(minutes), 
    .small_sec_out(small_sec),  
    .hours_out(hours)
);

always #1 clk_10000Hz = ~clk_10000Hz;

initial begin
    clk_10000Hz = 0;
    reset = 1;
    inc_short = 0;
    time_setting_enable = 1;
    time_hr_or_min = 0;
    counter_enable = 0;
    #100
    reset = 0;
    inc_short = 1;
    #50
    inc_short = 0;
    #50
    time_hr_or_min = 1;
    #50
    inc_short = 1;
    #50
    inc_short = 0;
    #50
    time_setting_enable = 0;
    #50
    counter_enable = 1;
end
endmodule 