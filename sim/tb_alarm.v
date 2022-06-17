`timescale 1ns/1ps
module alarm_tb();

reg setting_enable;
reg set_hr_or_min;
reg inc_short;
reg [13:0] hour;
reg [13:0] minute;

wire beep_out;
wire [13:0] hour_out;
wire [13:0] minute_out;

alarm alarm(
    .reg setting_enable(setting_enable),
    .set_hr_or_min(set_hr_or_min),
    .inc_short(inc_short),
    .hour(hour),
    .minute(minute),

    .beep_out(beep_out),
    .hour_out(hour_out),
    .minute_out(minute_out)
);

initial begin

    //initilize
    setting_enable = 0;
    set_hr_or_min = 0;
    inc_short = 0;
    hour = 0;
    minute = 0;
    #10

    //start
    setting_enable = 1;
    set_hr_or_min = 1;
    #10
    inc_short = 1;
    #10
    inc_short = 0;
    setting_enable = 0;
    #10
    minute = 1;
    #10
    minute = 2;
    #10
    setting_enable = 1;
    #10
    inc_short = 1;
    #10
    inc_short = 0;
    #10
    $finish;

end

endmodule
