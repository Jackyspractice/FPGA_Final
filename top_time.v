`timescale 1ms/1ns
module tb_counter_to_BCD(
    //real input
    input clk,
    input inc_short,
    input inc_long,
    input set,
    input sw,
    input reset,

    //real output
    output [3:0] scan,
    output [6:0] decoder_out
);

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
//mux_time_mode out
wire [3:0] left_ONES;
wire [3:0] left_TENS;
wire [3:0] right_ONES;
wire [3:0] right_TENS;
/*******************************************/
//mux_to_sevseg out
wire [3:0] to_sevseg;
/*******************************************/
//
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
//[00, counter], [10, regalarm], [11, regstopwatch]
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
mux_time_mode mux_time_mode(
    .hr_or_min(mux_outmode),
    .second_ONES(second_ONES),
    .second_TENS(second_TENS),
    .min_ONES(min_ONES),
    .min_TENS(min_TENS),
    .hr_ONES(hr_ONES),
    .hr_TENS(hr_TENS),

    .left_ONES(left_ONES),
    .left_TENS(left_TENS),
    .right_ONES(right_ONES),
    .right_TENS(right_TENS)
);

mux_to_sevseg mux_to_sevseg(
    .sel(sel),
    .left_ONES(left_ONES),
    .left_TENS(left_TENS),
    .right_ONES(right_ONES),
    .right_TENS(right_TENS),

    .to_sevseg(to_sevseg)
);

sev_decoder sev_decoder(
    .x(to_sevseg),

    .seg(decoder_out)
);

endmodule 
