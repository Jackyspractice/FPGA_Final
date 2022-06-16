module Bigger_BCD(
    input [13:0] small_sec_in,
    input [13:0] sec_in,
    input [13:0] min_in,
    input [13:0] hr_in,

    output [3:0] small_ONES, small_TENS, small_HUNDREDS, small_thousands;
    output [3:0] second_ONES, second_TENS;
    output [3:0] min_ONES, min_TENS;
    output [3:0] hr_ONES, hr_TENS;
);

BCD BCD_small(
    .A(small_sec_in),

    .ONES(small_ONES),
    .TENS(small_TENS),
    .HUNDREDS(small_HUNDREDS),
    .thousands(small_thousands)
);
BCD BCD_sec(
    .A(sec_in),

    .ONES(second_ONES),
    .TENS(second_TENS)
);
BCD BCD_min(
    .A(min_in),

    .ONES(min_ONES),
    .TENS(min_TENS)
);
BCD BCD_hr(
    .A(hr_in),

    .ONES(hr_ONES),
    .TENS(hr_TENS)
);

endmodule
