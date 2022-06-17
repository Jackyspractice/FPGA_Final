module FSM(
    input clk,
    input inc_short,
    input inc_long,
    input set,
    input sw,

    output reg counter_enable,
    output reg [1:0]mux,
    //mux, choose to display counter or regtime, 
    //[00, counter], [10, regalarm], [11, regstopwatch]
    output reg mux_outmode,
    //tell mux to output hr_min or min_sec
    //[0, hr_min], [1, min_sec]

    output reg time_setting_enable,
    output reg time_hr_or_min,//regtime, to choose mode setting hr0 or min1
    output reg regalarm_setting_enable,
    output reg regalarm_hr_or_min,//regalarm, to choose mode setting hr0 or min1
    output reg stopwatch_count_enable,
    output reg stopwatch_reset,
    output reg [3:0] state
);

parameter hr_min = 0, min_sec = 1, set_hr = 2, set_min = 3, set_alarm_hr = 4, set_alarm_min = 5,
    stopwatch_idle = 6, stopwatch_start = 7, stopwatch_pause = 8;

reg [3:0] stateNext;

initial begin
    
    stateNext = hr_min;

end


always @(posedge clk) begin

    state <= stateNext;

end

always @(state, inc_short, inc_long, set, sw) begin

    case (state) 

        hr_min: begin
            counter_enable <= 1;
            mux_outmode <= 0;
            mux <= 2'b00;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 0;
            stateNext = hr_min;
            if (inc_short == 1 && inc_long == 0 && set == 0 && sw == 0) stateNext = min_sec;
            else if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = set_hr;
            else if (inc_short == 0 && inc_long == 1 && set == 0 && sw == 0) stateNext = set_alarm_hr;
            else if (inc_short == 0 && inc_long == 0 && set == 0 && sw == 1) stateNext = stopwatch_idle;
        end

        min_sec: begin
            counter_enable <= 1;
            mux_outmode <= 1;
            mux <= 2'b00;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 0;
            stateNext = min_sec;
            if (inc_short == 1 && inc_long == 0 && set == 0 && sw == 0) stateNext = hr_min;
            else if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = set_hr;
            else if (inc_short == 0 && inc_long == 1 && set == 0 && sw == 0) stateNext = set_alarm_hr;
            else if (inc_short == 0 && inc_long == 0 && set == 0 && sw == 1) stateNext = stopwatch_idle;
        end

        set_hr: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b00;
            time_setting_enable <= 1;
            time_hr_or_min <= 0;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 0;
            stateNext = set_hr;
            if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = set_min;
        end

        set_min: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b00;
            time_setting_enable <= 1;
            time_hr_or_min <= 1;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 0;
            stateNext = set_min;
            if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = hr_min;
        end

        set_alarm_hr: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b10;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 1;
            regalarm_hr_or_min <= 0;
            stopwatch_count_enable <= 0;
            stateNext = set_alarm_hr;
            if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = set_alarm_min;
        end

        set_alarm_min: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b10;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 1;
            regalarm_hr_or_min <= 1;
            stopwatch_count_enable <= 0;
            stateNext = set_alarm_min;
            if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = hr_min;
        end

        stopwatch_idle: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b11;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 0;
            stopwatch_reset <= 1;
            stateNext = stopwatch_idle;
            if (inc_short == 0 && inc_long == 0 && set == 0 && sw == 1) stateNext = stopwatch_start;
            else if (inc_short == 0 && inc_long == 0 && set == 1 && sw == 0) stateNext = hr_min;
        end

        stopwatch_start: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b11;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 1;
            stopwatch_reset <= 0;
            stateNext = stopwatch_start;
            if (inc_short == 0 && inc_long == 0 && set == 0 && sw == 1) stateNext = stopwatch_pause;
        end

        stopwatch_pause: begin
            counter_enable <= 0;
            mux_outmode <= 0;
            mux <= 2'b11;
            time_setting_enable <= 0;
            regalarm_setting_enable <= 0;
            stopwatch_count_enable <= 0;
            stopwatch_reset <= 0;
            stateNext = stopwatch_pause;
            if (inc_short == 1 && inc_long == 0 && set == 0 && sw == 0) stateNext = stopwatch_idle;
        end
        
        default: begin
            stateNext = hr_min;
        end

    endcase

end

endmodule
