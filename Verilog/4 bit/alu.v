module alu(x, y, opcode);
	input [3:0] x, y, opcode;
	wire [2:0] overflow;
	wire [3:0] f0, f1, f2, f3, f4, result;
	wire w5, zero, set, isoverflowed;
	assign zero = 1'b0;
	
	/*
		w1 - adder output
		w2 - bitwise or output
		w3 - bitwise and output
		w4 - subtracter output
		w5 - slt output
		overflow[0] - overflow indicator from adder
		overflow[1] - overflow indicator from subtractor
		overflow[2] - overflow indicator from slt
	*/
	add op0 (x,y,f0,overflow[0],zero);
	bitwiseor op1 (x,y,f1);
	bitwiseand op2 (x,y,f2);
	sub op3 (x, y, f3, overflow[1]);
	slt op4 (x, y, set, overflow[2]);
	
	//out outputselector (f0, f1, f2, f3, set, opcode[0], opcode[1], opcode[2], overflow[0], overflow[1], overflow[2], result, isoverflowed); 
	
	// TODO: Implement output selector using w1-w5
	
endmodule

/* ========================================================= */
/*                   OUTPUT SELECTOR MODULE                  */
/* ========================================================= */
module out(f0, f1, f2, f3, s0, s1, s2, overflow0, overflow1, overflow2, result, isoverflowed);
	input [3:0] f0, f1, f2, f3;
	input s0, s1, s2, overflow0, overflow1, overflow2, set;
	output [3:0] result;
	output isoverflowed;
	wire zero;
	assign zero = 1'b0;
	
	mux8to1 mux0 (f0[0], f1[0], f2[0], f3[0], set, zero, zero, zero, s0, s1, s2, result[0]);
	mux8to1 mux1 (f0[1], f1[1], f2[1], f3[1], zero, zero, zero, zero, s0, s1, s2, result[1]);
	mux8to1 mux2 (f0[2], f1[2], f2[2], f3[2], zero, zero, zero, zero, s0, s1, s2, result[2]);
	mux8to1 mux3 (f0[3], f1[3], f2[3], f3[3], zero, zero, zero, zero, s0, s1, s2, result[3]);
	
	
	assign f0 = 4'b1001;
	assign f1 = 4'b0011;
	assign f2 = 4'b1010;
	assign f3 = 4'b1011;
	assign set = 1;
	assign s2 = 1;
	assign s1 = 0;
	assign s0 = 0;
	initial
		begin
		$monitor($time,,"result=%b, s2=%b, s1=%b, s0=%b, f0=%b, f1=%b, f2=%b, f3=%b",result,s2,s1,s0,f0,f1,f2,f3);

		end
	
endmodule

/* ========================================================= */
/*                     32BIT ADDER MODULE                    */
/* ========================================================= */
module add(x,y,s,cout,cin);
	input [3:0] x,y;
	output [3:0] s;
	input cin;
	output cout;
	wire c[3:0];
	
	fulladder f0 (x[0],y[0],cin,s[0],c[0]);
	fulladder f1 (x[1],y[1],c[0],s[1],c[1]);
	fulladder f2 (x[2],y[2],c[1],s[2],c[2]);
	fulladder f3 (x[3],y[3],c[2],s[3],cout);
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
	input [3:0] x,y;
	wire [3:0] x, y, one, ynot,ynotplusone;
	wire overflow1,overflow2,zero;
	output [3:0] f;
	output overflow;
	assign one = 4'b1;
	assign zero = 1'b0;

	not(ynot[0],y[0]);
	not(ynot[1],y[1]);
	not(ynot[2],y[2]);
	not(ynot[3],y[3]);
	
	add adder0(one,ynot,ynotplusone,overflow1,zero);
	add adder1(x,ynotplusone,f,overflow2,zero);
	
	or(overflow, overflow1, overflow2);
endmodule

/* ========================================================= */
/*                 32BIT BITWISE AND MODULE                 */
/* ========================================================= */
module bitwiseand(x,y,f);
	input [3:0] x, y;
	output [3:0] f;
	
	and(f[0],x[0],y[0]);
	and(f[1],x[1],y[1]);
	and(f[2],x[2],y[2]);
	and(f[3],x[3],y[3]);
endmodule

/* ========================================================= */
/*                 32BIT BITWISE OR MODULE                 */
/* ========================================================= */
module bitwiseor(x,y,f);
	input [3:0] x, y;
	output [3:0] f;
	
	or(f[0],x[0],y[0]);
	or(f[1],x[1],y[1]);
	or(f[2],x[2],y[2]);
	or(f[3],x[3],y[3]);
endmodule

/* ========================================================= */
/*                  32BIT SLT MODULE                         */
/* ========================================================= */
module slt(x,y,set,overflow);
	input [3:0] x, y;
	output set, overflow;
	wire [3:0] ynot, one, sum, result;
	assign one = 4'b1;
	wire overflow1, overflow2, zero;
	assign zero = 1'b0;
	
	not(ynot[0],y[0]);
	not(ynot[1],y[1]);
	not(ynot[2],y[2]);
	not(ynot[3],y[3]);
	
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