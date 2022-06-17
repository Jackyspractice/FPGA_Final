module stopwath_counter(
    input clk_10000Hz,
    input count_enable,
    input reset,

    output reg [13:0] small_sec_out //14bits
);

reg [13:0] small_sec; //14bits

always @(posedge clk_10000Hz or posedge reset) begin
       
    if (reset) begin
        small_sec <= 14'b0;
        small_sec_out <= 14'b0;
    end

    else if (count_enable) begin

        small_sec <= small_sec + 1;
        if (small_sec == 14'b10011100010000) begin
            small_sec_out <= 0;
            small_sec <= 0;
            //seconds <= seconds + 1;
        end
        else small_sec_out <= small_sec;

    end

end

endmodule
