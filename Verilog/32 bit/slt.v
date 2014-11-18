/* ========================================================= */
/*                  32BIT SLT MODULE                         */
/* ========================================================= */
module slt(x,y,f,overflow);
	input [31:0] x,y;
	output [31:0] f;
	wire [31:0] result;
	output overflow;
	
	assign f = 0;
	assign f[0] = result[31];
	
	sub subtractor0 (x,y,result,overflow);
	
	assign x = 14507;
	assign y = 97400;
	initial
		begin
		$monitor($time,,"x=%d, y=%d, result=%b",x,y,b);
		end
endmodule

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
	
	assign x = 32'b00000000000000000000000000001001;
	assign y = 32'b00000000000000000000000000010011;
	initial
		begin
		$monitor($time,,"one=%b, y=%b, f=%d, overflow=%b, overflow1=%b, overflow2=%b",one,y,f,overflow,overflow1,overflow2);
		end
	
endmodule

/* ========================================================= */
/*              UNCHANGED DEPENDENCY MODULES                 */
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
	fulladder f4 (x[4],y[4],c[2],s[3],c[3]);
	fulladder f5 (x[5],y[5],c[3],s[4],c[4]);
	fulladder f6 (x[6],y[6],c[4],s[5],c[5]);
	fulladder f7 (x[7],y[7],c[5],s[6],c[6]);
	fulladder f8 (x[8],y[8],c[6],s[7],c[7]);
	fulladder f9 (x[9],y[9],c[7],s[8],c[8]);
	fulladder f10 (x[10],y[10],c[8],s[9],c[9]);
	fulladder f11 (x[11],y[11],c[9],s[10],c[10]);
	fulladder f12 (x[12],y[12],c[10],s[11],c[11]);
	fulladder f13 (x[13],y[13],c[11],s[12],c[12]);
	fulladder f14 (x[14],y[14],c[12],s[13],c[13]);
	fulladder f15 (x[15],y[15],c[13],s[14],c[14]);
	fulladder f16 (x[16],y[16],c[14],s[15],c[15]);
	fulladder f17(x[17],y[17],c[15],s[16],c[16]);
	fulladder f18 (x[18],y[18],c[16],s[17],c[17]);
	fulladder f19 (x[19],y[19],c[17],s[18],c[18]);
	fulladder f20 (x[20],y[20],c[18],s[19],c[19]);
	fulladder f21 (x[21],y[21],c[19],s[20],c[20]);
	fulladder f22 (x[22],y[22],c[20],s[21],c[21]);
	fulladder f23 (x[23],y[23],c[21],s[22],c[22]);
	fulladder f24 (x[24],y[24],c[22],s[23],c[23]);
	fulladder f25 (x[25],y[25],c[23],s[24],c[24]);
	fulladder f26 (x[26],y[26],c[24],s[25],c[25]);
	fulladder f27 (x[27],y[27],c[25],s[26],c[26]);
	fulladder f28 (x[28],y[28],c[26],s[27],c[27]);
	fulladder f29 (x[29],y[29],c[27],s[28],c[28]);
	fulladder f30 (x[30],y[30],c[28],s[29],c[29]);
	fulladder f31 (x[31],y[31],c[29],s[30],cout);
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


