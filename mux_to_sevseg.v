module mux_to_sevseg(
    input [1:0] sel,
    input [3:0] left_ONES,
    input [3:0] left_TENS,
    input [3:0] right_ONES,
    input [3:0] right_TENS,

    output reg [3:0] to_sevseg
);

always @(sel[1:0]) begin

    case(sel)

       2'b00: to_sevseg = right_ONES;

       2'b01: to_sevseg = right_TENS;

       2'b10: to_sevseg = left_ONES;

       2'b11: to_sevseg = left_TENS;

    endcase 

end

endmodule
