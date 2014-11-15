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
	
	/* FOR TESTING:
	//assign x = 4'b1001;
	//assign y = 4'b0011;
	initial
		begin
		$monitor($time,,"x=%b, y=%b, f=%b, overflow=%b, overflow1=%b, overflow2=%b",x,y,f,overflow,overflow1,overflow2);
		end
	*/
endmodule

/* ========================================================= */
/*              UNCHANGED DEPENDENCY MODULES                 */
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
