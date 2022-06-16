module reg_time(
    input [13:0] hr_in,
    input [13:0] min_in,
    input [13:0] sec_in,
    input [13:0] small_sec_in,
    input reset,

    input setting_enable,
    input set_hr_or_min, //hr0, min1
    input inc_short,

    output [13:0] hr_out,
    output [13:0] min_out,
    output [13:0] sec_out,
    output [13:0] small_sec_out
);

reg [13:0] hr_store;
reg [13:0] min_store;
reg [13:0] sec_store;
reg [13:0] small_sec_store;

assign hr_out = hr_store;
assign min_out = min_store;
assign sec_out = sec_store;
assign small_sec_out = small_sec_store;

always @(posedge reset) begin
    small_sec_store <= 0;
    sec_store <= 0;
    min_store <= 0;
    hr_store <= 0;
end


always @(small_sec_in or hr_in or min_in or sec_in or posedge inc_short) begin
    
    if (setting_enable == 0) begin

        small_sec_store <= small_sec_in;
        sec_store <= sec_in;
        min_store <= min_in;
        hr_store <= hr_in;

    end

    else if (setting_enable == 1) begin

        if (set_hr_or_min == 0) begin //hr

            if (inc_short == 1) begin
                hr_store <= hr_store + 1;
                if (hr_store == 24) begin
                    hr_store <= 0;
                end
            end

        end

        else if (set_hr_or_min == 1) begin //min

            if (inc_short == 1) begin
                min_store <= min_store + 1;
                if (min_store == 60) begin
                    min_store <= 0;
                end
            end

        end

    end

end

endmodule
