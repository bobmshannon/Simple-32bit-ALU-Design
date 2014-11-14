module alu(x, y, opcode);
	input [3:0] x, y, opcode;
	wire [2:0] overflow;
	wire [3:0] w1, w2, w3, w4;
	wire w5, zero;
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
	add adder (x,y,w1,overflow[0],zero);
	bitwiseor bitwiseorop (x,y,w2);
	bitwiseand bitwiseandop (x,y,w3);
	sub subtracter (x, y, w4, overflow[1]);
	slt sltop (x, y, w5, overflow[2]);
	
	// TODO: Implement output selector using w1-w5
	
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
/*                 32BIT BITWISE AND MODULE                 */
/* ========================================================= */
module bitwiseand(x,y,f);
	input [3:0] x, y;
	output [3:0] f;
	
	and(f[0],x[0],y[0]);
	and(f[1],x[1],y[1]);
	and(f[2],x[2],y[2]);
	and(f[3],x[3],y[3]);
	
	/* FOR TESTING:
	assign x = 4'b1001;
	assign y = 4'b0011;
	
	initial
		begin
			$monitor($time,,"x=%b, y=%b, f=%b",x,y,f);
		end
	*/
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
	
	/* FOR TESTING:
	assign x = 4'b1001;
	assign y = 4'b0011;
	
	initial
		begin
			$monitor($time,,"x=%b, y=%b, f=%b",x,y,f);
		end
	*/
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
	
	/* FOR TESTING:
	assign x = 4'b0001;
	assign y = 4'b0111;
	initial
		begin

		$monitor($time,,"x=%b, y=%b, set=%b, overflow=%b sum=%b result=%b",x,y,set,overflow,sum,result);
		$display($time,,"x=%b, y=%b, set=%b, overflow=%b sum=%b result=%b",x,y,set,overflow,sum,result);
		$display($time,,"x=%b, y=%b, set=%b, overflow=%b sum=%b result=%b",x,y,set,overflow,sum,result);
		end
	*/
endmodule