module BCD(A,ONES,TENS,HUNDREDS,thousands);
input [13:0] A;
output [3:0] ONES, TENS;
output [3:0] HUNDREDS;
output [3:0] thousands;

wire [3:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
    c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26;
wire [3:0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,
    d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26;

assign d1 = {1'b0,A[13:11]};
assign d2 = {c1[2:0],A[10]};
assign d3 = {c2[2:0],A[9]};
assign d4 = {c3[2:0],A[8]};
assign d5 = {c4[2:0],A[7]};
assign d6 = {c5[2:0],A[6]};
assign d7 = {c6[2:0],A[5]};
assign d8 = {c7[2:0],A[4]};
assign d9 = {c8[2:0],A[3]};
assign d10 = {c9[2:0],A[2]};
assign d11 = {c10[2:0],A[1]};

assign d12 = {1'b0,c1[3],c2[3],c3[3]};
assign d13 = {c12[2:0],c4[3]};
assign d14 = {c13[2:0],c5[3]};
assign d15 = {c14[2:0],c6[3]};
assign d16 = {c15[2:0],c7[3]};
assign d17 = {c16[2:0],c8[3]};
assign d18 = {c17[2:0],c9[3]};
assign d19 = {c18[2:0],c10[3]};

assign d20 = {1'b0,c12[3],c13[3],c14[3]};
assign d21 = {c20[2:0],c15[3]};
assign d22 = {c21[2:0],c16[3]};
assign d23 = {c22[2:0],c17[3]};
assign d24 = {c23[2:0],c18[3]};

assign d25 = {1'b0,c20[3],c21[3],c22[3]};
assign d26 = {c25[2:0],c23[3]};
add3 m1(d1,c1);
add3 m2(d2,c2);
add3 m3(d3,c3);
add3 m4(d4,c4);
add3 m5(d5,c5);
add3 m6(d6,c6);
add3 m7(d7,c7);
add3 m8(d8,c8);
add3 m9(d9,c9);
add3 m10(d10,c10);
add3 m11(d11,c11);
add3 m12(d12,c12);
add3 m13(d13,c13);
add3 m14(d14,c14);
add3 m15(d15,c15);
add3 m16(d16,c16);
add3 m17(d17,c17);
add3 m18(d18,c18);
add3 m19(d19,c19);
add3 m20(d20,c20);
add3 m21(d21,c21);
add3 m22(d22,c22);
add3 m23(d23,c23);
add3 m24(d24,c24);
add3 m25(d25,c25);
add3 m26(d26,c26);
assign ONES = {c11[2:0],A[0]};
assign TENS = {c19[2:0],c11[3]};
assign HUNDREDS = {c24[2:0],c19[3]};
assign thousands = {c26[2:0],c24[3]};

endmodule