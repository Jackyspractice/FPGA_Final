module alarm(
    input setting_enable,
    input set_hr_or_min,
    input inc_short,
    input [13:0] hour,
    input [13:0] minute,
    
    output wire beep_out,
    output reg [13:0] hour_out,
    output reg [13:0] minute_out
);

reg beep;
reg [13:0] hour_alarm;
reg [13:0] minute_alarm;

assign beep_out = beep;


initial begin
    hour_alarm <= 0;
    minute_alarm <= 58;
end

always @(hour ,minute) begin
    if ( hour == hour_alarm && minute == minute_alarm )
        beep <= 1;
    else
        beep <= 0;
end

always @(posedge inc_short) begin
    if (setting_enable == 1) begin

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

    end

    end

endmodule