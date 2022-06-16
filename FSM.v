module FSM(
    input clk,
    input inc_short,
    input inc_long,
    input set,
    input sw,

    output reg counter_enable,
    output reg [1:0]mux,
    //mux, choose to display counter or regtime, 
    //[00, counter], [01, regtime], [10, regalarm], [11, regstopwatch]
    output reg mux_outmode,
    //tell mux to output hr_min or min_sec
    //[0, hr_min], [1, min_sec]

    output reg time_setting_enable,
    output reg time_hr_or_min,//regtime, to choose mode setting hr0 or min1
    output reg regalarm_setting_enable,
    output reg regalarm_hr_or_min//regalarm, to choose mode setting hr0 or min1
);

parameter hr_min = 0, min_sec = 1, set_hr = 2, set_min = 3, set_alarm_hr = 4, set_alarm_min = 5,
    stopwatch_idle = 6, stopwatch_start = 7, stopwatch_pause = 8;

reg [3:0] state, stateNext;


always @(posedge clk) begin

    state <= stateNext;

end

always @(posedge clk, inc_short, inc_long, set, sw) begin

    case (state) 

        hr_min: begin
            counter_enable <= 1;
            mux_outmode <= 0;
            mux <= 2'b00;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stateNext = hr_min;
            if (inc_short == 1) stateNext = min_sec;
            else if (set == 1) stateNext = set_hr;
            else if (inc_long == 1) stateNext = set_alarm_hr;
            else if (sw == 1) stateNext = stopwatch_idle;
        end

        min_sec: begin
            counter_enable <= 1;
            mux_outmode <= 1;
            mux <= 2'b00;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stateNext = min_sec;
            if (inc_short == 1) stateNext = hr_min;
            else if (set == 1) stateNext = set_hr;
            else if (inc_long == 1) stateNext = set_alarm_hr;
            else if (sw == 1) stateNext = stopwatch_idle;
        end

        set_hr: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b01;
            regtime_setting_enable <= 1;
            regtime_hr_or_min <= 0;
            regalarm_setting_enable <= 0;
            stateNext = set_hr;
            if (set == 1) stateNext = set_min;
        end

        set_min: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b01;
            regtime_setting_enable <= 1;
            regtime_hr_or_min <= 1;
            regalarm_setting_enable <= 0;
            stateNext = set_min;
            if (set == 1) stateNext = hr_min;
        end

        set_alarm_hr: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b10;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 1;
            stateNext = set_alarm_hr;
            if (set == 1) stateNext = set_alarm_min;
        end

        set_alarm_min: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b10;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 1;
            stateNext = set_alarm_min;
            if (set == 1) stateNext = hr_min;
        end

        stopwatch_idle: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b11;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 1;
            stateNext = stopwatch_idle;
            if (sw == 1) stateNext = stopwatch_start;
            else if (set == 1) stateNext = hr_min;
        end

        stopwatch_start: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b11;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stateNext = stopwatch_start;
            if (sw == 1) stateNext = stopwatch_pause;
        end

        stopwatch_pause: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b11;
            regtime_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stateNext = stopwatch_pause;
            if (inc_short == 1) stateNext = stopwatch_idle;
        end
        
        default: begin
            state = hr_min;
            stateNext = hr_min;
        end

    endcase

end

endmodule
