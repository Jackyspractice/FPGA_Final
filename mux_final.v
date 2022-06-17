module mux_final(
    input [1:0] mode, //00 counter, 10 alarm, 11 stopwatch

    input [3:0] counter_left_one,
    input [3:0] counter_left_ten,
    input [3:0] counter_right_one,
    input [3:0] counter_right_ten,

    input [3:0] alarm_left_one,
    input [3:0] alarm_left_ten,
    input [3:0] alarm_right_one,
    input [3:0] alarm_right_ten,

    input [3:0] stopwatch_one,
    input [3:0] stopwatch_ten,
    input [3:0] stopwatch_hun,
    input [3:0] stopwatch_thousand,


    output reg [3:0] left_one,
    output reg [3:0] left_ten,
    output reg [3:0] right_one,
    output reg [3:0] right_ten
);

parameter counter = 0, alarm = 2, stopwatch = 3;

always @(mode[1:0]) begin

    case (mode)

        counter: begin
            left_one <= counter_left_one;
            left_ten <= counter_left_ten;
            right_one <= counter_right_one;
            right_ten <= counter_right_ten;
        end

        alarm: begin
            left_one <= alarm_left_one;
            left_ten <= alarm_left_ten;
            right_one <= alarm_right_one;
            right_ten <= alarm_right_ten;
        end

        stopwatch: begin
            right_one <= stopwatch_one;
            right_ten <= stopwatch_ten;
            left_one <= stopwatch_hun;
            left_ten <= stopwatch_thousand;
        end

        default: begin
            left_one <= counter_left_one;
            left_ten <= counter_left_ten;
            right_one <= counter_right_one;
            right_ten <= counter_right_ten;
        end

    endcase

end

endmodule
