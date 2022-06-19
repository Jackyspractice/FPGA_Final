module top_time(
    //real input
    input clk,
    input inc,
    input set,
    input sw,

    //real output
    output [3:0] scan,
    output [6:0] decoder_out,
    output [3:0] state,
    output beep
);

/*******************************************/
//short or long out
wire db_inc_short;
wire db_inc_long;
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
//debounce out
wire db_set, db_sw;
/*******************************************/
//BCDs outs
wire [3:0] small_ONES, small_TENS, small_HUNDREDS, small_thousands;
wire [3:0] second_ONES, second_TENS;
wire [3:0] min_ONES, min_TENS;
wire [3:0] hr_ONES, hr_TENS;
/*******************************************/
//stopwatch BCD out
wire [3:0] stopwatch_ONES;
wire [3:0] stopwatch_TENS;
wire [3:0] stopwatch_HUNDREDS;
wire [3:0] stopwatch_thousands;
//alarm BCD out
wire [3:0] alarm_hr_ONES;
wire [3:0] alarm_hr_TENS;
wire [3:0] alarm_min_ONES;
wire [3:0] alarm_min_TENS;
//final mux out
wire [3:0] to_sev_left_one;
wire [3:0] to_sev_left_ten;
wire [3:0] to_sev_right_one;
wire [3:0] to_sev_right_ten;
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
wire stopwatch_count_enable;
wire stopwatch_reset;
/*******************************************/
//stopwatch out
wire [13:0] small_from_stopwatch;
/*******************************************/
//alarm out
wire [13:0] hour_from_alarm;
wire [13:0] min_from_alarm;
/*******************************************/
short_or_long short_or_long(
    .inc(inc),
    .clk(clk_10000Hz),

    .inc_short(db_inc_short),
    .inc_long(db_inc_long)
);

debounce debounce_set(
    .inp(set),
    .clk(clk_10000Hz),

    .outp(db_set)
);
debounce debounce_sw(
    .inp(sw),
    .clk(clk_10000Hz),

    .outp(db_sw)
);

FSM FSM(
    .clk(clk_10000Hz),
    .inc_short(db_inc_short),
    .inc_long(db_inc_long),
    .set(db_set),
    .sw(db_sw),
    
    .counter_enable(counter_enable),
    .mux(mux),
    .mux_outmode(mux_outmode),
    .time_setting_enable(time_setting_enable),
    .time_hr_or_min(time_hr_or_min),
    .regalarm_setting_enable(regalarm_setting_enable),
    .regalarm_hr_or_min(regalarm_hr_or_min),
    .stopwatch_count_enable(stopwatch_count_enable),
    .stopwatch_reset(stopwatch_reset),
    .state(state)
);
clkdiv clkdiv(
    .mclk(clk),

    .clk_counter(clk_10000Hz),
    .clk_scan(clk_scan)
);
control_which_scan control_which_scan(
    .clk(clk_scan),

    .sel(sel)
);
sev_scan sev_scan(
    .sel(sel),

    .scan(scan)
);
counter counter(
    .clk_10000Hz(clk_10000Hz),
    .enable(counter_enable),
    .setting_enable(time_setting_enable),
    .set_hr_or_min(time_hr_or_min),
    .inc_short(db_inc_short),

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

stopwath_counter stopwath_counter(
    .clk_10000Hz(clk_10000Hz),
    .count_enable(stopwatch_count_enable),
    .reset(stopwatch_reset),

    .small_sec_out(small_from_stopwatch)
);

BCD stopwatch_BCD(
    .A(small_from_stopwatch),

    .ONES(stopwatch_ONES),
    .TENS(stopwatch_TENS),
    .HUNDREDS(stopwatch_HUNDREDS),
    .thousands(stopwatch_thousands)
);

alarm alarm(
    .setting_enable(regalarm_setting_enable),
    .set_hr_or_min(regalarm_hr_or_min),
    .inc_short(db_inc_short),
    .hour(hours),
    .minute(minutes),

    .beep_out(beep),
    .hour_out(hour_from_alarm),
    .minute_out(min_from_alarm)
);

BCD alarm_hr_BCD(
    .A(hour_from_alarm),

    .ONES(alarm_hr_ONES),
    .TENS(alarm_hr_TENS)
);

BCD alarm_min_BCD(
    .A(min_from_alarm),

    .ONES(alarm_min_ONES),
    .TENS(alarm_min_TENS)
);

mux_final mux_final(
    .mode(mux),

    .counter_left_one(left_ONES),
    .counter_left_ten(left_TENS),
    .counter_right_one(right_ONES),
    .counter_right_ten(right_TENS),

    .alarm_left_one(alarm_hr_ONES),
    .alarm_left_ten(alarm_hr_TENS),
    .alarm_right_one(alarm_min_ONES),
    .alarm_right_ten(alarm_min_TENS),

    .stopwatch_one(stopwatch_ONES),
    .stopwatch_ten(stopwatch_TENS),
    .stopwatch_hun(stopwatch_HUNDREDS),
    .stopwatch_thousand(stopwatch_thousands),

    .left_one(to_sev_left_one),
    .left_ten(to_sev_left_ten),
    .right_one(to_sev_right_one),
    .right_ten(to_sev_right_ten)
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
    .left_ONES(to_sev_left_one),
    .left_TENS(to_sev_left_ten),
    .right_ONES(to_sev_right_one),
    .right_TENS(to_sev_right_ten),

    .to_sevseg(to_sevseg)
);

sev_decoder sev_decoder(
    .x(to_sevseg),

    .seg(decoder_out)
);

endmodule 
