//out hr[5:0], min[6], sec[6]
module counter(
    input clk,
    input reset,
    input enable,
    input setting_enable,
    input set_hr_or_min, //hr0, min1
    input inc_short,

    output wire [13:0] small_sec_out, //14bits
    output wire [13:0] seconds_out, //6bits
    output wire [13:0] minutes_out, //6bits
    output wire [13:0] hours_out //5bits
);

reg [13:0] small_sec; //14bits
reg [13:0] seconds; //6bits
reg [13:0] minutes; //6bits
reg [13:0] hours; //5bits

assign small_sec_out = small_sec;
assign seconds_out = seconds;
assign minutes_out = minutes;
assign hours_out = hours;

always @(posedge inc_short) begin

    if (setting_enable == 1) begin

        if (set_hr_or_min == 0) begin //hr

            if (inc_short == 1) begin
                hours <= hours + 1;
                if (hours == 24) begin
                    hours <= 0;
                end
            end

        end

        else if (set_hr_or_min == 1) begin //min

            if (inc_short == 1) begin
                minutes <= minutes + 1;
                if (minutes == 60) begin
                    minutes <= 0;
                end
            end

        end

    end

end

always @(posedge(clk) or posedge(reset))
    begin

        if(reset == 1'b1) begin
            small_sec <= 0;
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        end

        else if (enable == 1) begin
                small_sec <= small_sec + 1;
                if (small_sec == 14'b10011100010000) begin
                    small_sec <= 0;
                    seconds <= seconds + 1;
                end
                if(seconds == 14'b111100) begin
                    seconds <= 0;
                    minutes <= minutes + 1;
                end
                if(minutes == 14'b111100) begin
                    minutes <= 0; 
                    hours <= hours + 1;
                end
                if(hours ==  14'b11000) begin
                    hours <= 0;
                end
         end

    end
endmodule