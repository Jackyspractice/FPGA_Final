//out hr[5:0], min[6], sec[6]
module counter(
    input clk_10000Hz,
    input enable,
    input setting_enable,
    input set_hr_or_min, //hr0, min1
    input inc_short,

    output reg [13:0] small_sec_out, //14bits
    output reg [13:0] seconds_out, //6bits
    output reg [13:0] minutes_out, //6bits
    output reg [13:0] hours_out //5bits
);

reg [13:0] small_sec; //14bits
reg [13:0] seconds; //6bits
reg [13:0] minutes; //6bits
reg [13:0] hours; //5bits

initial begin
    small_sec <= 0;
    seconds <= 0;
    minutes <= 0;
    hours <= 0;
end

always @(posedge clk_10000Hz)
    begin
        
        small_sec_out <= small_sec;
        seconds_out <= seconds;
        minutes_out <= minutes;
        hours_out <= hours;

        if (enable == 1) begin
                small_sec <= small_sec + 1;
                if (small_sec == 14'b10011100010000) begin
                    small_sec_out <= 0;
                    small_sec <= 0;
                    seconds <= seconds + 1;
                end
                else small_sec_out <= small_sec;
                
                if(seconds == 14'b111100) begin
                    seconds_out <= 0;
                    seconds <= 0;
                    minutes <= minutes + 1;
                end
                else seconds_out <= seconds;
                
                if(minutes == 14'b111100) begin
                    minutes_out <= 0; 
                    minutes <= 0;
                    hours <= hours + 1;
                end
                else minutes_out <= minutes;
                
                if(hours ==  14'b11000) begin
                    hours_out <= 0;
                    hours <= 0;
                end
                else hours_out <= hours;
                
        end

        else if (setting_enable == 1) begin

            if (set_hr_or_min == 0) begin //hr

                if (inc_short == 1) begin
                    hours <= hours + 1;
                    if (hours == 23) begin
                        hours_out <= 0;
                        hours <= 0;
                    end
                    else hours_out <= hours;
                end

            end

            else if (set_hr_or_min == 1) begin //min

                if (inc_short == 1) begin
                    minutes <= minutes + 1;
                    if (minutes == 59) begin
                        minutes_out <= 0;
                        minutes <= 0;
                    end
                    else minutes_out <= minutes;
                end

            end

    end

    end
endmodule