`timescale 1ms/1ns
module tb_counter_to_BCD();

//real input
reg inc_short;
reg inc_long;
reg set;
reg sw;

//real output
reg [3:0] scan;

//tb input
reg clk;
reg reset;

//tb output
/*******************************************/
//clkdiv out
wire clk_10000Hz;
wire clk_scan;
/*******************************************/
//which out
wire [1:0] sel;
/*******************************************/
//counter out
wire [13:0] seconds;
wire [13:0] minutes;
wire [13:0] hours;
wire [13:0] small_sec;
/*******************************************/

/*******************************************/
//BCDs outs
wire [3:0] small_ONES, small_TENS, small_HUNDREDS, small_thousands;
wire [3:0] second_ONES, second_TENS;
wire [3:0] min_ONES, min_TENS;
wire [3:0] hr_ONES, hr_TENS;
/*******************************************/

/*******************************************/
//FSM out
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
/*******************************************/

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
clkdiv clkdiv(
    .mclk(clk),

    .clk_counter(clk_10000Hz),
    .clk_scan(clk_scan)
);
control_which_scan control_which_scan(
    .clk(clk_scan),
    .clr(reset),

    .sel(sel)
);
sev_scan sev_scan(
    .sel(sel),

    .scan(scan)
);
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
Bigger_BCD counter_BCD(
    .small_sec_in(small_sec),
    .sec_in(seconds),
    .min_in(minutes),
    .hr_in(hours),

    .small_ONES(small_ONES),
    .small_TENS(small_TENS),
    .small_HUNDREDS(small_HUNDREDS),
    .small_thousands(small_thousands),
    .second_ONES(second_ONES),
    .second_TENS(second_TENS),
    .min_ONES(min_ONES),
    .min_TENS(min_TENS),
    .hr_ONES(hr_ONES),
    .hr_TENS(hr_TENS)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    inc_short = 0;
    inc_long = 0;
    set = 0;
    sw = 0;
    #10
    reset = 0;
end
endmodule 
