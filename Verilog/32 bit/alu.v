/*
	Input is 32 bit numbers x and y
	
	Opcode 		Operation
	 000           ADD
	 001		   OR
	 010           AND
	 011           SUB
	 100           SLT
	 101        *UNUSED*
	 110		*UNUSED*
	 111		*UNUSED*
*/
module alu(x, y, opcode);
	input [31:0] x, y;
	input [2:0] opcode;
	wire [2:0] overflow;
	wire [31:0] f0, f1, f2, f3, f4, result;
	wire w5, zero, set, isoverflowed, cout;
	assign zero = 1'b0;
	
	add op0 (x,y,f0,overflow[0],zero);
	bitwiseor op1 (x,y,f1);
	bitwiseand op2 (x,y,f2);
	sub op3 (x, y, f3, overflow[1]);
	slt op4 (x, y, set, overflow[2]);
	
	out outputselector (f0,f1,f2,f3,set,opcode[0],opcode[1],opcode[2],overflow[0],overflow[1],overflow[2],result,isoverflowed,cout);
	
	assign x = 1000000000; 
	assign y = 3000000000; 
	assign opcode = 4'b000;
	initial
		begin
		$display("x=%d, y=%d, opcode=%b, result=%d, isoverflowed=%d, zero=%b, cout=%b",x,y,opcode,result,isoverflowed,zero,cout);
		$monitor("x=%d, y=%d, opcode=%b, result=%d, isoverflowed=%d, zero=%b, cout=%b",x,y,opcode,result,isoverflowed,zero,cout);
		$display("x=%d, y=%d, opcode=%b, result=%d, isoverflowed=%d, zero=%b, cout=%b",x,y,opcode,result,isoverflowed,zero,cout);
		end
		
endmodule

/* ========================================================= */
/*                   OUTPUT SELECTOR MODULE                  */
/* ========================================================= */
module out(f0, f1, f2, f3, set, s0, s1, s2, overflow0, overflow1, overflow2, result, isoverflowed, cout);
	input [31:0] f0, f1, f2, f3;
	input s0, s1, s2, overflow0, overflow1, overflow2, set;
	output [31:0] result;
	output isoverflowed, cout;
	wire zero;
	assign zero = 1'b0;
	assign cout = isoverflowed;
	
	mux8to1 mux0 (f0[0], f1[0], f2[0], f3[0], set, zero, zero, zero, s0, s1, s2, result[0]);
	mux8to1 mux1 (f0[1], f1[1], f2[1], f3[1], zero, zero, zero, zero, s0, s1, s2, result[1]);
	mux8to1 mux2 (f0[2], f1[2], f2[2], f3[2], zero, zero, zero, zero, s0, s1, s2, result[2]);
	mux8to1 mux3 (f0[3], f1[3], f2[3], f3[3], zero, zero, zero, zero, s0, s1, s2, result[3]);
	mux8to1 mux4 (f0[4], f1[4], f2[4], f3[4], zero, zero, zero, zero, s0, s1, s2, result[4]);
	mux8to1 mux5 (f0[5], f1[5], f2[5], f3[5], zero, zero, zero, zero, s0, s1, s2, result[5]);
	mux8to1 mux6 (f0[6], f1[6], f2[6], f3[6], zero, zero, zero, zero, s0, s1, s2, result[6]);	
	mux8to1 mux7 (f0[7], f1[7], f2[7], f3[7], zero, zero, zero, zero, s0, s1, s2, result[7]);
	mux8to1 mux8 (f0[8], f1[8], f2[8], f3[8], zero, zero, zero, zero, s0, s1, s2, result[8]);
	mux8to1 mux9 (f0[9], f1[9], f2[9], f3[9], zero, zero, zero, zero, s0, s1, s2, result[9]);
	mux8to1 mux10 (f0[10], f1[10], f2[10], f3[10], zero, zero, zero, zero, s0, s1, s2, result[10]);
	mux8to1 mux11 (f0[11], f1[11], f2[11], f3[11], zero, zero, zero, zero, s0, s1, s2, result[11]);
	mux8to1 mux12 (f0[12], f1[12], f2[12], f3[12], zero, zero, zero, zero, s0, s1, s2, result[12]);
	mux8to1 mux13 (f0[13], f1[13], f2[13], f3[13], zero, zero, zero, zero, s0, s1, s2, result[13]);
	mux8to1 mux14 (f0[14], f1[14], f2[14], f3[14], zero, zero, zero, zero, s0, s1, s2, result[14]);
	mux8to1 mux15 (f0[15], f1[15], f2[15], f3[15], zero, zero, zero, zero, s0, s1, s2, result[15]);
	mux8to1 mux16 (f0[16], f1[16], f2[16], f3[16], zero, zero, zero, zero, s0, s1, s2, result[16]);
	mux8to1 mux17 (f0[17], f1[17], f2[17], f3[17], zero, zero, zero, zero, s0, s1, s2, result[17]);
	mux8to1 mux18 (f0[18], f1[18], f2[18], f3[18], zero, zero, zero, zero, s0, s1, s2, result[18]);
	mux8to1 mux19 (f0[19], f1[19], f2[19], f3[19], zero, zero, zero, zero, s0, s1, s2, result[19]);
	mux8to1 mux20 (f0[20], f1[20], f2[20], f3[20], zero, zero, zero, zero, s0, s1, s2, result[20]);
	mux8to1 mux21 (f0[21], f1[21], f2[21], f3[21], zero, zero, zero, zero, s0, s1, s2, result[21]);
	mux8to1 mux22 (f0[22], f1[22], f2[22], f3[22], zero, zero, zero, zero, s0, s1, s2, result[22]);
	mux8to1 mux23 (f0[23], f1[23], f2[23], f3[23], zero, zero, zero, zero, s0, s1, s2, result[23]);
	mux8to1 mux24 (f0[24], f1[24], f2[24], f3[24], zero, zero, zero, zero, s0, s1, s2, result[24]);
	mux8to1 mux25 (f0[25], f1[25], f2[25], f3[25], zero, zero, zero, zero, s0, s1, s2, result[25]);
	mux8to1 mux26 (f0[26], f1[26], f2[26], f3[26], zero, zero, zero, zero, s0, s1, s2, result[26]);
	mux8to1 mux27 (f0[27], f1[27], f2[27], f3[27], zero, zero, zero, zero, s0, s1, s2, result[27]);
	mux8to1 mux28 (f0[28], f1[28], f2[28], f3[28], zero, zero, zero, zero, s0, s1, s2, result[28]);
	mux8to1 mux29 (f0[29], f1[29], f2[29], f3[29], zero, zero, zero, zero, s0, s1, s2, result[29]);
	mux8to1 mux30 (f0[30], f1[30], f2[30], f3[30], zero, zero, zero, zero, s0, s1, s2, result[30]);
	mux8to1 mux31 (f0[31], f1[31], f2[31], f3[31], zero, zero, zero, zero, s0, s1, s2, result[31]);
	
	mux8to1 mux32 (overflow0, overflow1, zero, zero, overflow2, zero, zero, zero, s0, s1, s2, isoverflowed);
endmodule

/* ========================================================= */
/*                     32BIT ADDER MODULE                    */
/* ========================================================= */
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

	xor #1
		g1(w1, a, b),
		g2(s, w1, c);
	and #1
		g3(w2, c, b),
		g4(w3, c, a),
		g5(w4, a, b);
	or #1
		g6(cout, w2, w3, w4);
endmodule

/* ========================================================= */
/*                 32BIT SUBTRACTOR MODULE                   */
/* ========================================================= */
module sub(x,y,f,overflow);
	input [31:0] x,y;
	wire [31:0] x, y, one, ynot,ynotplusone;
	wire overflow1,overflow2,zero;
	output [31:0] f;
	output overflow;
	assign one = 32'b1;
	assign zero = 1'b0;

	not(ynot[0],y[0]);
	not(ynot[1],y[1]);
	not(ynot[2],y[2]);
	not(ynot[3],y[3]);
	not(ynot[4],y[4]);
	not(ynot[5],y[5]);
	not(ynot[6],y[6]);
	not(ynot[7],y[7]);
	not(ynot[8],y[8]);
	not(ynot[9],y[9]);
	not(ynot[10],y[10]);
	not(ynot[11],y[11]);
	not(ynot[12],y[12]);
	not(ynot[13],y[13]);
	not(ynot[14],y[14]);
	not(ynot[15],y[15]);
	not(ynot[16],y[16]);
	not(ynot[17],y[17]);
	not(ynot[18],y[18]);
	not(ynot[19],y[19]);
	not(ynot[20],y[20]);
	not(ynot[21],y[21]);
	not(ynot[22],y[22]);
	not(ynot[23],y[23]);
	not(ynot[24],y[24]);
	not(ynot[25],y[25]);
	not(ynot[26],y[26]);
	not(ynot[27],y[27]);
	not(ynot[28],y[28]);
	not(ynot[29],y[29]);
	not(ynot[30],y[30]);
	not(ynot[31],y[31]);

	add adder0(one,ynot,ynotplusone,overflow1,zero);
	add adder1(x,ynotplusone,f,overflow2,zero);
	
	or(overflow, overflow1, overflow2);
endmodule

/* ========================================================= */
/*                 32BIT BITWISE AND MODULE                 */
/* ========================================================= */
module bitwiseand(x,y,f);
	input [31:0] x, y;
	output [31:0] f;
	
	and(f[0],x[0],y[0]);
	and(f[1],x[1],y[1]);
	and(f[2],x[2],y[2]);
	and(f[3],x[3],y[3]);
	and(f[4],x[4],y[4]);
	and(f[5],x[5],y[5]);
	and(f[6],x[6],y[6]);
	and(f[7],x[7],y[7]);
	and(f[8],x[8],y[8]);
	and(f[9],x[9],y[9]);
	and(f[10],x[10],y[10]);
	and(f[11],x[11],y[11]);
	and(f[12],x[12],y[12]);
	and(f[13],x[13],y[13]);
	and(f[14],x[14],y[14]);
	and(f[15],x[15],y[15]);
	and(f[16],x[16],y[16]);
	and(f[17],x[17],y[17]);
	and(f[18],x[18],y[18]);
	and(f[19],x[19],y[19]);
	and(f[20],x[20],y[20]);
	and(f[21],x[21],y[21]);
	and(f[22],x[22],y[22]);
	and(f[23],x[23],y[23]);
	and(f[24],x[24],y[24]);
	and(f[25],x[25],y[25]);
	and(f[26],x[26],y[26]);
	and(f[27],x[27],y[27]);
	and(f[28],x[28],y[28]);
	and(f[29],x[29],y[29]);
	and(f[30],x[30],y[30]);
	and(f[31],x[31],y[31]);
endmodule

/* ========================================================= */
/*                 32BIT BITWISE OR MODULE                 */
/* ========================================================= */
module bitwiseor(x,y,f);
	input [31:0] x, y;
	output [31:0] f;
	
	or(f[0],x[0],y[0]);
	or(f[1],x[1],y[1]);
	or(f[2],x[2],y[2]);
	or(f[3],x[3],y[3]);
	or(f[4],x[4],y[4]);
	or(f[5],x[5],y[5]);
	or(f[6],x[6],y[6]);
	or(f[7],x[7],y[7]);
	or(f[8],x[8],y[8]);
	or(f[9],x[9],y[9]);
	or(f[10],x[10],y[10]);
	or(f[11],x[11],y[11]);
	or(f[12],x[12],y[12]);
	or(f[13],x[13],y[13]);
	or(f[14],x[14],y[14]);
	or(f[15],x[15],y[15]);
	or(f[16],x[16],y[16]);
	or(f[17],x[17],y[17]);
	or(f[18],x[18],y[18]);
	or(f[19],x[19],y[19]);
	or(f[20],x[20],y[20]);
	or(f[21],x[21],y[21]);
	or(f[22],x[22],y[22]);
	or(f[23],x[23],y[23]);
	or(f[24],x[24],y[24]);
	or(f[25],x[25],y[25]);
	or(f[26],x[26],y[26]);
	or(f[27],x[27],y[27]);
	or(f[28],x[28],y[28]);
	or(f[29],x[29],y[29]);
	or(f[30],x[30],y[30]);
	or(f[31],x[31],y[31]);
endmodule

/* ========================================================= */
/*                  32BIT SLT MODULE                         */
/* ========================================================= */
module slt(x,y,set,overflow);
	input [31:0] x, y;
	output set, overflow;
	wire [31:0] ynot, one, sum, result;
	assign one = 4'b1;
	wire overflow1, overflow2, zero;
	assign zero = 1'b0;
	
	not(ynot[0],y[0]);
	not(ynot[1],y[1]);
	not(ynot[2],y[2]);
	not(ynot[3],y[3]);
	not(ynot[4],y[4]);
	not(ynot[5],y[5]);
	not(ynot[6],y[6]);
	not(ynot[7],y[7]);
	not(ynot[8],y[8]);
	not(ynot[9],y[9]);
	not(ynot[10],y[10]);
	not(ynot[11],y[11]);
	not(ynot[12],y[12]);
	not(ynot[13],y[13]);
	not(ynot[14],y[14]);
	not(ynot[15],y[15]);
	not(ynot[16],y[16]);
	not(ynot[17],y[17]);
	not(ynot[18],y[18]);
	not(ynot[19],y[19]);
	not(ynot[20],y[20]);
	not(ynot[21],y[21]);
	not(ynot[22],y[22]);
	not(ynot[23],y[23]);
	not(ynot[24],y[24]);
	not(ynot[25],y[25]);
	not(ynot[26],y[26]);
	not(ynot[27],y[27]);
	not(ynot[28],y[28]);
	not(ynot[29],y[29]);
	not(ynot[30],y[30]);
	not(ynot[31],y[31]);
	
	add adder0 (ynot,one,sum,overflow1,zero);
	add adder1 (x,sum,result,overflow2,zero);
	
	or(overflow,overflow1,overflow2);
	
	assign set = result[3];
endmodule

/* ========================================================= */
/*                    MULTIPLEXER MODULE(s)                  */
/* ========================================================= */
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
	
	and(w17, d1, s0);
	not(w15, s0);
	and(w18, w15, d0);
	or(f, w17, w18);
endmodule