module short_or_long(
    input inc,
    input clk_10000Hz,

    output reg inc_short,
    output reg inc_long
);

reg [14:0] counter;//3s
reg flag;

initial begin

    flag <= 1;
    counter <= 0;

end

always @(posedge clk_10000Hz) begin

    if (inc == 1) begin
        counter <= counter + 1;
        flag <= 0;
    end
    else if (inc == 0 && flag == 0) begin

        if (counter >= 15'h01c2) begin//10000
            inc_long <= 1;
            inc_short <= 0;
            counter <= 0;
        end

        else if (counter >= 3) begin

            inc_short <= 1;
            inc_long <= 0;
            counter <= 0;

        end

        flag <= 1;

    end

    if (flag == 1) begin

        inc_short <= 0;
        inc_long <= 0;

    end

end

endmodule
