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
/*                       TESTING                             */
/* ========================================================= */
/*
module testbench();
	wire [3:0] x,y,s;
	wire cin,cout; 
	testAdder test (x,y,s,cout,cin);
	add adder (x,y,s,cout,cin);
endmodule

module testAdder(a,b,s,cout,cin);
	input [3:0] s;
	input cout;
	output [3:0] a,b;
	output cin;
	reg [3:0] a,b;
	reg cin;
	
	initial
		begin
		$monitor($time,,"a=%d, b=%d, c=%b, s=%d,cout=%b",a,b,cin,s,cout);
		$display($time,,"a=%d, b=%d, c=%b, s=%d,cout=%b",a,b,cin,s,cout);
		#20 a=2; b=3; cin=0;
		#20 a=1; b=7; cin=0;
		#20  // Required for iverilog to show final values
		$display($time,,"a=%d, b=%d, c=%b, s=%d,cout=%b",a,b,cin,s,cout);
		end
endmodule*/