/* **************************************************************** */
/*             32 bit ALU design with delay simulation              */
/*                        Author: Robert Shannon                    */
/*                       E-mail: rshannon@buffalo.edu               */
/* **************************************************************** */
`timescale 1ns/1ns

/*
/* ========================================================= */
/*                   UNIT DELAY SIMULATION                   */
/* ========================================================= */
module testbench();
	wire [31:0] x,y,f;
	wire [2:0] opcode;
	wire cin,cout,overflow,zero; 
	testALU test (x, y, opcode, f, overflow, cout, zero);
	alu alu0 (x, y, opcode, f, overflow, cout, zero);
endmodule

module testALU(x, y, opcode, f, overflow, cout, zero);
	input [31:0] f;
	input cout, overflow, zero;
	output [31:0] x,y;
	output [2:0] opcode;
	reg [31:0] x,y;
	reg [2:0] opcode;
	assign overflow = 0;
 
	initial
		begin
		/*
		$display("====================================================================================");
		$display("                   32 bit ALU Functional Simulation (unit delay)                    ");
		$display("                            Author: Robert Shannon			                      ");
		$display("                          Email: rshannon@buffalo.edu		                          ");
		$display("====================================================================================");
		*/
		
		// Example #1 - ADD
		x=1024; y=128; opcode=0;
		#94 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%d, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=842; y=986; opcode=0;
		#113 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%d, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=1024; y=128; opcode=0;
		#93 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%d, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		
		// Example #2 - SUB
		/*
		x=8108; y=9375; opcode=3;
		#202 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=842; y=986; opcode=3;
		#231 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=8108; y=9375; opcode=3;
		#199 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		*/
		
		// Example #3 - AND
		/*
		x=32'b00100011100011101000111010110101; y=32'b10111101011001001101011111110110; opcode=2;
		#57 $display ($time,,"1. x=%b, y=%b, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=32'b10101011100100001101011000001011; y=32'b00010100011110101110000000010011; opcode=2; 
		#57 $display ($time,,"1. x=%b, y=%b, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=32'b00100011100011101000111010110101; y=32'b10111101011001001101011111110110; opcode=2;
		#57 $display ($time,,"1. x=%b, y=%b, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		*/
		// Example #4 - OR
		/*
		x=32'b10111101111011000011100011101110; y=32'b11101011110011110011111101010100; opcode=1;
		#61 $display ($time,,"1. x=%b, y=%b, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=32'b00010110010000100000101010001111; y=32'b11001111111010000100011000111011; opcode=1;
		#61 $display ($time,,"1. x=%b, y=%b, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=32'b10111101111011000011100011101110; y=32'b11101011110011110011111101010100; opcode=1;
		#61 $display ($time,,"1. x=%b, y=%b, opcode=%b, f=%b, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		*/
		
		// Example #5 - SLT
		/*
		x=71; y=57; opcode=4;
		#273 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%d, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=11; y=57; opcode=4;
		#278 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%d, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		x=71; y=57; opcode=4;
		#273 $display ($time,,"1. x=%d, y=%d, opcode=%b, f=%d, overflow=%b, zero=%d, cout=%b",x,y,opcode,f,overflow, zero,cout);
		*/
		end

endmodule

/*
	A 32 bit ALU with overflow detection.
	
	@inputs x, y, opcode
	@outputs f, overflow, cout, zero
	@dependencies none
*/
module alu(x, y, opcode, f, overflow, cout, zero);
	input [31:0] x, y;
	input [2:0] opcode;
	output overflow, zero, cout;
	output [31:0] f;
	wire [2:0] opoverflow;
	wire [31:0] f0, f1, f2, f3, f4, result;
	wire w5, zero, isoverflowed, cout;
	
	add op0 (x,y,f0,opoverflow[0],zero);
	bitwiseor op1 (x,y,f1);
	bitwiseand op2 (x,y,f2);
	sub op3 (x, y, f3, opoverflow[1]);
	slt op4 (x, y, f4, opoverflow[2]);
	out outputselector (f0,f1,f2,f3,f4,opcode[0],opcode[1],opcode[2],opoverflow[0],opoverflow[1],opoverflow[2],f,isoverflowed,cout);
	iszero zerochecker (f, zero);
endmodule

/*
	Selects the correct output F based on the opcode.
	
	@inputs f0, f1, f2, f3, f4, s0, s1, s2, overflow0, overflow1, overflow2
	@outputs result, isoverflowed, cout
	@dependencies mux8to1 or32
*/
module out(f0, f1, f2, f3, f4, s0, s1, s2, overflow0, overflow1, overflow2, result, isoverflowed, cout);
	input [31:0] f0, f1, f2, f3, f4;
	input s0, s1, s2, overflow0, overflow1, overflow2;
	output [31:0] result;
	output isoverflowed, cout;
	assign cout = isoverflowed;
	assign zero = 0;
	
	mux8to1 mux0 (f0[0], f1[0], f2[0], f3[0], f4[0], zero, zero, zero, s0, s1, s2, result[0]);
	mux8to1 mux1 (f0[1], f1[1], f2[1], f3[1], f4[1], zero, zero, zero, s0, s1, s2, result[1]);
	mux8to1 mux2 (f0[2], f1[2], f2[2], f3[2], f4[2], zero, zero, zero, s0, s1, s2, result[2]);
	mux8to1 mux3 (f0[3], f1[3], f2[3], f3[3], f4[3], zero, zero, zero, s0, s1, s2, result[3]);
	mux8to1 mux4 (f0[4], f1[4], f2[4], f3[4], f4[4], zero, zero, zero, s0, s1, s2, result[4]);
	mux8to1 mux5 (f0[5], f1[5], f2[5], f3[5], f4[5], zero, zero, zero, s0, s1, s2, result[5]);
	mux8to1 mux6 (f0[6], f1[6], f2[6], f3[6], f4[6], zero, zero, zero, s0, s1, s2, result[6]);	
	mux8to1 mux7 (f0[7], f1[7], f2[7], f3[7], f4[7], zero, zero, zero, s0, s1, s2, result[7]);
	mux8to1 mux8 (f0[8], f1[8], f2[8], f3[8], f4[8], zero, zero, zero, s0, s1, s2, result[8]);
	mux8to1 mux9 (f0[9], f1[9], f2[9], f3[9], f4[9], zero, zero, zero, s0, s1, s2, result[9]);
	mux8to1 mux10 (f0[10], f1[10], f2[10], f3[10], f4[10], zero, zero, zero, s0, s1, s2, result[10]);
	mux8to1 mux11 (f0[11], f1[11], f2[11], f3[11], f4[11], zero, zero, zero, s0, s1, s2, result[11]);
	mux8to1 mux12 (f0[12], f1[12], f2[12], f3[12], f4[12], zero, zero, zero, s0, s1, s2, result[12]);
	mux8to1 mux13 (f0[13], f1[13], f2[13], f3[13], f4[13], zero, zero, zero, s0, s1, s2, result[13]);
	mux8to1 mux14 (f0[14], f1[14], f2[14], f3[14], f4[14], zero, zero, zero, s0, s1, s2, result[14]);
	mux8to1 mux15 (f0[15], f1[15], f2[15], f3[15], f4[15], zero, zero, zero, s0, s1, s2, result[15]);
	mux8to1 mux16 (f0[16], f1[16], f2[16], f3[16], f4[16], zero, zero, zero, s0, s1, s2, result[16]);
	mux8to1 mux17 (f0[17], f1[17], f2[17], f3[17], f4[17], zero, zero, zero, s0, s1, s2, result[17]);
	mux8to1 mux18 (f0[18], f1[18], f2[18], f3[18], f4[18], zero, zero, zero, s0, s1, s2, result[18]);
	mux8to1 mux19 (f0[19], f1[19], f2[19], f3[19], f4[19], zero, zero, zero, s0, s1, s2, result[19]);
	mux8to1 mux20 (f0[20], f1[20], f2[20], f3[20], f4[20], zero, zero, zero, s0, s1, s2, result[20]);
	mux8to1 mux21 (f0[21], f1[21], f2[21], f3[21], f4[21], zero, zero, zero, s0, s1, s2, result[21]);
	mux8to1 mux22 (f0[22], f1[22], f2[22], f3[22], f4[22], zero, zero, zero, s0, s1, s2, result[22]);
	mux8to1 mux23 (f0[23], f1[23], f2[23], f3[23], f4[23], zero, zero, zero, s0, s1, s2, result[23]);
	mux8to1 mux24 (f0[24], f1[24], f2[24], f3[24], f4[24], zero, zero, zero, s0, s1, s2, result[24]);
	mux8to1 mux25 (f0[25], f1[25], f2[25], f3[25], f4[25], zero, zero, zero, s0, s1, s2, result[25]);
	mux8to1 mux26 (f0[26], f1[26], f2[26], f3[26], f4[26], zero, zero, zero, s0, s1, s2, result[26]);
	mux8to1 mux27 (f0[27], f1[27], f2[27], f3[27], f4[27], zero, zero, zero, s0, s1, s2, result[27]);
	mux8to1 mux28 (f0[28], f1[28], f2[28], f3[28], f4[28], zero, zero, zero, s0, s1, s2, result[28]);
	mux8to1 mux29 (f0[29], f1[29], f2[29], f3[29], f4[29], zero, zero, zero, s0, s1, s2, result[29]);
	mux8to1 mux30 (f0[30], f1[30], f2[30], f3[30], f4[30], zero, zero, zero, s0, s1, s2, result[30]);
	mux8to1 mux31 (f0[31], f1[31], f2[31], f3[31], f4[31], zero, zero, zero, s0, s1, s2, result[31]);
	
	mux8to1 mux32 (overflow0, overflow1, zero, zero, overflow2, zero, zero, zero, s0, s1, s2, isoverflowed);

endmodule

module iszero(f, zero);
	input [31:0] f;
	output zero;

	or #6(w1,f[0],f[1]);
	or #6(w2,f[2],f[3]);
	or #6(w3,f[4],f[5]);
	or #6(w4,f[6],f[7]);
	or #6(w5,f[8],f[9]);
	or #6(w6,f[10],f[11]);
	or #6(w7,f[12],f[13]);
	or #6(w8,f[14],f[15]);
	or #6(w9,f[16],f[17]);
	or #6(w10,f[18],f[19]);
	or #6(w11,f[20],f[21]);
	or #6(w12,f[22],f[23]);
	or #6(w13,f[24],f[25]);
	or #6(w14,f[26],f[27]);
	or #6(w15,f[28],f[29]);
	or #6(w16,f[30],f[31]);
	
	or #6(w17, w1, w2);
	or #6(w18, w3, w4);
	or #6(w19, w5, w6);
	or #6(w20, w7, w8);
	or #6(w21, w9, w10);
	or #6(w22, w11, w12);
	or #6(w23, w13, w14);
	or #6(w24, w15, w16);
	
	or #6(w25, w17, w18);
	or #6(w26, w19, w20);
	or #6(w27, w21, w22);
	or #6(w28, w23, w24);
	
	or #6(w29, w25, w26);
	or #6(w30, w27, w28);
	
	or #6(w31, w29, w30);
	
	not #1(zero, w31);
endmodule

/*
	Performs addition on two 32 bit numbers.
	
	@inputs x, y, cin
	@outputs s, cout
	@dependencies fulladder
*/
module add(x,y,s,cout,cin);
	input [31:0] x,y;
	output [31:0] s;
	input cin;
	output cout;
	wire c[31:0];

	fulladder f0 (x[0],y[0],cin,s[0],c[0]);
	fulladder f1 (x[1],y[1],c[0],s[1],c[1]);
	fulladder f2 (x[2],y[2],c[1],s[2],c[2]);
	fulladder f3 (x[3],y[3],c[2],s[3],c[3]);
	fulladder f4 (x[4],y[4],c[3],s[4],c[4]);
	fulladder f5 (x[5],y[5],c[4],s[5],c[5]);
	fulladder f6 (x[6],y[6],c[5],s[6],c[6]);
	fulladder f7 (x[7],y[7],c[6],s[7],c[7]);
	fulladder f8 (x[8],y[8],c[7],s[8],c[8]);
	fulladder f9 (x[9],y[9],c[8],s[9],c[9]);
	fulladder f10 (x[10],y[10],c[9],s[10],c[10]);
	fulladder f11 (x[11],y[11],c[10],s[11],c[11]);
	fulladder f12 (x[12],y[12],c[11],s[12],c[12]);
	fulladder f13 (x[13],y[13],c[12],s[13],c[13]);
	fulladder f14 (x[14],y[14],c[13],s[14],c[14]);
	fulladder f15 (x[15],y[15],c[14],s[15],c[15]);
	fulladder f16 (x[16],y[16],c[15],s[16],c[16]);
	fulladder f17 (x[17],y[17],c[16],s[17],c[17]);
	fulladder f18 (x[18],y[18],c[17],s[18],c[18]);
	fulladder f19 (x[19],y[19],c[18],s[19],c[19]);
	fulladder f20 (x[20],y[20],c[19],s[20],c[20]);
	fulladder f21 (x[21],y[21],c[20],s[21],c[21]);
	fulladder f22 (x[22],y[22],c[21],s[22],c[22]);
	fulladder f23 (x[23],y[23],c[22],s[23],c[23]);
	fulladder f24 (x[24],y[24],c[23],s[24],c[24]);
	fulladder f25 (x[25],y[25],c[24],s[25],c[25]);
	fulladder f26 (x[26],y[26],c[25],s[26],c[26]);
	fulladder f27 (x[27],y[27],c[26],s[27],c[27]);
	fulladder f28 (x[28],y[28],c[27],s[28],c[28]);
	fulladder f29 (x[29],y[29],c[28],s[29],c[29]);
	fulladder f30 (x[30],y[30],c[29],s[30],c[30]);
	fulladder f31 (x[31],y[31],c[30],s[31],cout);
endmodule

module fulladder(a, b, c, s, cout);
	input a, b, c;
	output s, cout;

	xor #3
		g1(w1, a, b),
		g2(s, w1, c);
	and #2
		g3(w2, c, b),
		g4(w3, c, a),
		g5(w4, a, b);
	or #6
		g6(cout, w2, w3, w4);
endmodule

/*
	Performs two's complement subtraction on two 32 bit numbers.
	
	@inputs x, y
	@outputs f, overflow
	@dependencies add
*/
module sub(x,y,f,overflow);
	input [31:0] x,y;
	wire [31:0] x, y, one, ynot,ynotplusone;
	wire overflow1,overflow2,zero;
	output [31:0] f;
	output overflow;
	assign one = 32'b1;
	assign zero = 1'b0;

	not #1(ynot[0],y[0]);
	not #1(ynot[1],y[1]);
	not #1(ynot[2],y[2]);
	not #1(ynot[3],y[3]);
	not #1(ynot[4],y[4]);
	not #1(ynot[5],y[5]);
	not #1(ynot[6],y[6]);
	not #1(ynot[7],y[7]);
	not #1(ynot[8],y[8]);
	not #1(ynot[9],y[9]);
	not #1(ynot[10],y[10]);
	not #1(ynot[11],y[11]);
	not #1(ynot[12],y[12]);
	not #1(ynot[13],y[13]);
	not #1(ynot[14],y[14]);
	not #1(ynot[15],y[15]);
	not #1(ynot[16],y[16]);
	not #1(ynot[17],y[17]);
	not #1(ynot[18],y[18]);
	not #1(ynot[19],y[19]);
	not #1(ynot[20],y[20]);
	not #1(ynot[21],y[21]);
	not #1(ynot[22],y[22]);
	not #1(ynot[23],y[23]);
	not #1(ynot[24],y[24]);
	not #1(ynot[25],y[25]);
	not #1(ynot[26],y[26]);
	not #1(ynot[27],y[27]);
	not #1(ynot[28],y[28]);
	not #1(ynot[29],y[29]);
	not #1(ynot[30],y[30]);
	not #1(ynot[31],y[31]);

	add adder0(one,ynot,ynotplusone,overflow1,zero);
	add adder1(x,ynotplusone,f,overflow2,zero);
	
	or #6(overflow, overflow1, overflow2);
endmodule

/*
	Performs the bitwise AND operation using two 32 bit numbers

	@inputs x, y
	@outputs f
	@dependencies none
*/
module bitwiseand(x,y,f);
	input [31:0] x, y;
	output [31:0] f;
	
	and #2(f[0],x[0],y[0]);
	and #2(f[1],x[1],y[1]);
	and #2(f[2],x[2],y[2]);
	and #2(f[3],x[3],y[3]);
	and #2(f[4],x[4],y[4]);
	and #2(f[5],x[5],y[5]);
	and #2(f[6],x[6],y[6]);
	and #2(f[7],x[7],y[7]);
	and #2(f[8],x[8],y[8]);
	and #2(f[9],x[9],y[9]);
	and #2(f[10],x[10],y[10]);
	and #2(f[11],x[11],y[11]);
	and #2(f[12],x[12],y[12]);
	and #2(f[13],x[13],y[13]);
	and #2(f[14],x[14],y[14]);
	and #2(f[15],x[15],y[15]);
	and #2(f[16],x[16],y[16]);
	and #2(f[17],x[17],y[17]);
	and #2(f[18],x[18],y[18]);
	and #2(f[19],x[19],y[19]);
	and #2(f[20],x[20],y[20]);
	and #2(f[21],x[21],y[21]);
	and #2(f[22],x[22],y[22]);
	and #2(f[23],x[23],y[23]);
	and #2(f[24],x[24],y[24]);
	and #2(f[25],x[25],y[25]);
	and #2(f[26],x[26],y[26]);
	and #2(f[27],x[27],y[27]);
	and #2(f[28],x[28],y[28]);
	and #2(f[29],x[29],y[29]);
	and #2(f[30],x[30],y[30]);
	and #2(f[31],x[31],y[31]);
endmodule

/*
	Performs the bitwise OR operation using two 32 bit numbers

	@inputs x, y
	@outputs f
	@dependencies none
*/
module bitwiseor(x,y,f);
	input [31:0] x, y;
	output [31:0] f;
	
	or #6(f[0],x[0],y[0]);
	or #6(f[1],x[1],y[1]);
	or #6(f[2],x[2],y[2]);
	or #6(f[3],x[3],y[3]);
	or #6(f[4],x[4],y[4]);
	or #6(f[5],x[5],y[5]);
	or #6(f[6],x[6],y[6]);
	or #6(f[7],x[7],y[7]);
	or #6(f[8],x[8],y[8]);
	or #6(f[9],x[9],y[9]);
	or #6(f[10],x[10],y[10]);
	or #6(f[11],x[11],y[11]);
	or #6(f[12],x[12],y[12]);
	or #6(f[13],x[13],y[13]);
	or #6(f[14],x[14],y[14]);
	or #6(f[15],x[15],y[15]);
	or #6(f[16],x[16],y[16]);
	or #6(f[17],x[17],y[17]);
	or #6(f[18],x[18],y[18]);
	or #6(f[19],x[19],y[19]);
	or #6(f[20],x[20],y[20]);
	or #6(f[21],x[21],y[21]);
	or #6(f[22],x[22],y[22]);
	or #6(f[23],x[23],y[23]);
	or #6(f[24],x[24],y[24]);
	or #6(f[25],x[25],y[25]);
	or #6(f[26],x[26],y[26]);
	or #6(f[27],x[27],y[27]);
	or #6(f[28],x[28],y[28]);
	or #6(f[29],x[29],y[29]);
	or #6(f[30],x[30],y[30]);
	or #6(f[31],x[31],y[31]);
endmodule

/*
	Compares two 32 bit numbers X and Y. Asserts 1 if X < Y. 
	Else assert 0.

	@inputs x, y
	@outputs f, overflow
	@dependencies sub
*/
module slt(x,y,f,overflow);
	input [31:0] x,y;
	wire [31:0] result;
	output [31:0] f;
	output overflow;

	sub subtractor0 (x,y,result,overflow);
	
	assign f[0] = result[31];
	assign f[31:1] = 0;
endmodule

/*
	Implementation of an 8-1 MUX.

	@inputs d0, d1, d2, d3, d4, d5, d6, d7, s0, s1, s2
	@outputs f
	@dependencies mux4to1 mux2to1
*/
module mux8to1(d0, d1, d2, d3, d4, d5, d6, d7, s0, s1, s2, f);
	input d0, d1, d2, d3, d4, d5, d6, d7, s0, s1, s2;
	output f;
	
	mux4to1 mux0 (d0, d1, d2, d3, s0, s1, w1);
	mux4to1 mux1 (d4, d5, d6, d7, s0, s1, w2);
	mux2to1 mux2 (w1, w2, s2, f);
endmodule

module mux4to1(d0, d1, d2, d3, s0, s1, f);
	input d0, d1, d2, d3, s0, s1;
	output f;
	
	mux2to1 mux0 (d0, d1, s0, w1);
	mux2to1 mux1 (d2, d3, s0, w2);
	mux2to1 mux2 (w1, w2, s1, f);
endmodule

module mux2to1(d0, d1, s0, f);
	input d0, d1, s0;
	output f;
	
	and #2(w17, d1, s0);
	not #1(w15, s0);
	and #2(w18, w15, d0);
	or #6(f, w17, w18);
endmodule