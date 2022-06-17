module alarm(
    input setting_enable,
    input set_hr_or_min,
    input inc_short,
    input [13:0] hour,
    input [13:0] minute,
    input clk,
    
    output reg beep_out,
    output reg [13:0] hour_out,
    output reg [13:0] minute_out
);

reg [13:0] hour_alarm;
reg [13:0] minute_alarm;
reg beep;
reg state, stateNext;


parameter read = 0, set = 1;



always @(posedge clk) begin
    state <= stateNext;
end

always @(state, setting_enable, inc_short) begin

    case (state)

    read: begin

        if (hour == hour_alarm && minute == minute_alarm) begin

            beep <= 1;
            beep_out <= 1;

        end


        stateNext <= read;
        if (setting_enable == 1) stateNext <= set;

    end

    set: begin

        beep <= 0;
        beep_out <= 0;

        if (set_hr_or_min == 0) begin //hr

                if (inc_short == 1) begin
                    hour_alarm <= hour_alarm + 1;
                    if (hour_alarm == 24) begin
                        hour_out <= 0;
                        hour_alarm <= 0;
                    end
                    else hour_out <= hour_alarm;
                end

        end

        else if (set_hr_or_min == 1) begin //min

            if (inc_short == 1) begin
                minute_alarm <= minute_alarm + 1;
                if (minute_alarm == 60) begin
                    minute_out <= 0;
                    minute_alarm <= 0;
                end
                else minute_out <= minute_alarm;
            end

        end

        if (setting_enable == 0) stateNext <= read;
    end


    endcase 

end

endmodule
