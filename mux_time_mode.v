module mux_time_mode(
    input hr_or_min,
    input [3:0] second_ONES,
    input [3:0] second_TENS,
    input [3:0] min_ONES,
    input [3:0] min_TENS,
    input [3:0] hr_ONES,
    input [3:0] hr_TENS,

    output reg [3:0] left_ONES,
    output reg [3:0] left_TENS,
    output reg [3:0] right_ONES,
    output reg [3:0] right_TENS
);

parameter hr_min = 0, min_sec = 1;

always @(*) begin

    case (hr_or_min)

        hr_min: begin

            left_ONES = hr_ONES;
            left_TENS = hr_TENS;
            right_ONES = min_ONES;
            right_TENS = min_TENS;

        end

        min_sec: begin

            left_ONES = min_ONES;
            left_TENS = min_TENS;
            right_ONES = second_ONES;
            right_TENS = second_TENS;

        end

        default: begin

            left_ONES = hr_ONES;
            left_TENS = hr_TENS;
            right_ONES = min_ONES;
            right_TENS = min_TENS;

        end

    endcase

end

endmodule
