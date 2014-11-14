module fulladder() ;
	wire w1, w2, w3, w4, s, cout;
	reg a, b, c;
	
	
		xor(w1, a, b);
		xor(s, w1, c);
	
		and(w2, c, b);
		and(w3, c, a);
		and(w4, a, b);
	
		or(cout, w2, w3, s4);
	initial
		begin
			$monitor($time,,,, "a=%b, b=%b, c=%b, s=%b, cout=%b",a, b, c, s, cout);
			$display($time,,,, "a=%b, b=%b, c=%b, s=%b, cout=%b", a, b, c, s, cout);
			#10	a=0; b=0; c=0;
			#10 a=1;
			#10 b=1;
			#10 c=1; a=0;
			#10 a=1;
			#10					// Required for iverilog to show final values
			$display($time,,,, "a=%b, b=%b, c=%b, s=%b, cout=%b", a, b, c, s, cout);
		end
		
endmodule


module fourBitAdder(x, y, s,cout, cin);
	input [3:0] x, y;
	output [3:0] s;
	input cin;
	output cout;
	wire c[3:0];
	
	fulladder f0 (x[0], y[0], cin, s[0], c[0]);
	fulladder f1 (x[1], y[1], c[0], s[1], c[1]);
	fulladder f2 (x[2], y[2], c[2], s[2], c[2]);
	fulladder f3 (x[3], y[3], c[3], s[3], cout);
endmodule
